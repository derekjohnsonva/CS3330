#!/usr/bin/env python3

import argparse
import difflib
import os.path
import re
import subprocess
import sys

def input_to_reference(input_file, reference_dir):
    input_base = os.path.basename(input_file)
    if input_base.endswith('.yo'):
        input_base = input_base[:-len('.yo')]
    return os.path.join(reference_dir, input_base + '.txt')


def create_one_reference(interpreter, program, input_file, reference_file, include_trace):
    extra_args = ['-t']
    if not include_trace:
        extra_args.append('-q')
    output = subprocess.check_output(
            [interpreter, program] + extra_args + [input_file]
    )
    with open(reference_file, 'wb') as fh:
        fh.write(output)

def create_all_references(interpreter, program, input_dir, reference_dir, include_trace=False):
    if not os.path.exists(reference_dir):
        os.makedirs(reference_dir)
    for yo_file in os.listdir(input_dir):
        if not yo_file.endswith('.yo'):
            continue
        yo_path = os.path.join(input_dir, yo_file)
        create_one_reference(interpreter, program, yo_path, input_to_reference(yo_path, reference_dir),
                include_trace=include_trace)

def strip_memory_lines(sim_output):
    sim_output = re.sub(rb'^\|  0x.*\n', b'', sim_output, flags=re.MULTILINE)
    return sim_output

def strip_pc_lines(sim_output):
    sim_output = re.sub(rb'^pc = .*', b'', sim_output, flags=re.MULTILINE)
    return sim_output

def strip_reg_lines(sim_output):
    sim_output = re.sub(rb'^\| R[ABS91].*\n', b'', sim_output, flags=re.MULTILINE)
    return sim_output

def strip_rax_lines(sim_output):
    sim_output = re.sub(rb'^\| RAX:\s+[0-9a-f]+', b'', sim_output, flags=re.MULTILINE)
    return sim_output

def strip_cycle_lines(sim_output):
    sim_output = re.sub(rb'^Cycles run: \d+', b'', sim_output, flags=re.MULTILINE)
    return sim_output

def compare_output(interpreter, program, input_file, reference_file, input_name=None, compare_trace=False,
                   ignore_memory=False, ignore_pc=False, ignore_regs=False, ignore_rax=False, ignore_cycles=False,
                   points=None):
    input_name = os.path.basename(input_name)
    extra_args = ['-t']
    if not compare_trace:
        extra_args.append('-q')
    output = subprocess.check_output(
            [interpreter, program] + extra_args + [input_file]
    )
    with open(reference_file, 'rb') as fh:
        expect_output = fh.read()
    output = output.strip()
    expect_output = expect_output.strip()
    if ignore_memory:
        output = strip_memory_lines(output)
        expect_output = strip_memory_lines(expect_output)
    if ignore_pc:
        output = strip_pc_lines(output)
        expect_output = strip_pc_lines(expect_output)
    if ignore_rax:
        output = strip_rax_lines(output)
        expect_output = strip_rax_lines(expect_output)
    if ignore_regs:
        output = strip_reg_lines(output)
        expect_output = strip_reg_lines(expect_output)
    if ignore_cycles:
        output = strip_cycle_lines(output)
        expect_output = strip_cycle_lines(expect_output)
    differences = None
    if output != expect_output:
        differences = '\n'.join(difflib.context_diff(
            expect_output.decode().split('\n'),
            output.decode().split('\n'),
            fromfile='expected output for ' + input_name,
            tofile='your output for ' + input_name,
            lineterm='',
        ))
    return (output == expect_output, differences)

def compare_outputs(interpreter, program, input_dir, yo_list, reference_dir, compare_trace=False,
                    ignore_pc=False, ignore_memory=False, ignore_regs=False, ignore_cycles=False,
                    ignore_rax=False, verbose=True):
    errors = []
    for yo_file in yo_list:
        default_options = dict(
            ignore_pc=ignore_pc,
            ignore_memory=ignore_memory,
            ignore_regs=ignore_regs,
            ignore_cycles=ignore_cycles,
        )
        if '+' in yo_file:
            (yo_file, options) = yo_file.split('+')
            extra_options = {}
            for option in options.split(','):
                if '=' in option:
                    k, v = option.split('=')
                    extra_options[k] = v
                else:
                    extra_options[option] = True
        else:
            extra_options = {}
        options = default_options
        options.update(extra_options)
        (matched, diffs) = compare_output(
                interpreter=interpreter,
                program=program,
                input_file=os.path.join(input_dir, yo_file),
                reference_file=input_to_reference(yo_file, reference_dir),
                input_name=yo_file,
                compare_trace=compare_trace,
                **options
        )
        if not matched:
            errors.append(yo_file)
            if verbose:
                sys.stderr.write('output did not match for {}:\n{}\n'.format(yo_file, diffs))
    return errors

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--yo-dir', default='y86',
                help='directory containing .yo files')
    parser.add_argument('--interpreter', default='./hclrs',
                help='path to HCL interpreter (default: ./hclrs)')
    parser.set_defaults(func=None)
    subparsers = parser.add_subparsers()
    parser_create_reference = subparsers.add_parser('create-reference',
                help='create a directory of reference outputs given a solution')
    parser_create_reference.add_argument('--include-trace', action='store_true',
                help='reference outputs should include state after each cycle')
    parser_create_reference.add_argument('hcl',
                help='HCL2D file to run')
    parser_create_reference.add_argument('output',
                help='output directory')
    def _create_reference(args):
        create_all_references(args.interpreter, args.hcl, args.yo_dir, args.output, include_trace=args.include_trace)
        print("Created references for {} into directory {}".format(args.hcl, args.output))
        return 0
    parser_create_reference.set_defaults(func=_create_reference)

    parser_test = subparsers.add_parser('test',
                help='compare an HCL2D executable versus reference; run ' +
                     'compare_with_reference.py test --help for more info')
    parser_test.add_argument('--compare-trace', action='store_true',
                help='compare cycle-by-cycle state rather than final state')
    parser_test.add_argument('--ignore-pc', action='store_true',
                help='ignore PC addresses fetched when comparing')
    parser_test.add_argument('--ignore-regs', action='store_true',
                help='ignore register values when comparing')
    parser_test.add_argument('--ignore-rax', action='store_true',
                help='ignore value of RAX when comparing')
    parser_test.add_argument('--ignore-memory', action='store_true',
                help='ignore memory values when comparing')
    parser_test.add_argument('--ignore-cycles', action='store_true',
                help='ignore final cycle count when comparing')
    parser_test.add_argument('--quiet', action='store_true',
                help='do not output test differences, only mismatched files')
    parser_test.add_argument('hcl',
                help='HCL2D file to test')
    parser_test.add_argument('yo_list',
                help='file containing list of .yo file names to test, one per line')
    parser_test.add_argument('reference',
                help='directory containing reference outputs')
    parser_test.add_argument('--exit-success', action='store_true')
    def _test_program(args):
        try:
            subprocess.check_call([args.interpreter, '--check', args.hcl])
        except subprocess.SubprocessError:
            print("{} failed to compile.".format(args.hcl))
            return 1
        with open(args.yo_list, 'r') as fh:
            yo_list = list(map(lambda s: s.strip(), fh.readlines()))
        errors = compare_outputs(args.interpreter, args.hcl, args.yo_dir, yo_list, args.reference,
                compare_trace=args.compare_trace,
                ignore_pc=args.ignore_pc,
                ignore_regs=args.ignore_regs,
                ignore_rax=args.ignore_rax,
                ignore_memory=args.ignore_memory,
                verbose=not args.quiet)
        if len(errors) == 0:
            print("{} passed all {} tests.".format(args.hcl, len(yo_list)))
            return 0
        else:
            print("{} failed {} tests: {}".format(args.hcl, len(errors), len(yo_list), ', '.join(errors)))
            print("(Note that not all tests may be weighted evenly when grading.)")
            if args.exit_success:
                return 0
            else:
                return 1
    parser_test.set_defaults(func=_test_program)
    args = parser.parse_args()
    if args.func:
        sys.exit(args.func(args))
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == '__main__':
    main()

#!/usr/bin/python3
import argparse
import csv

"""
Simulate based on the instruction trace read from 'fh'.

This is meant to represent a simple five-stage pipeline with:
* load/use hazards
* branch delay penalty for non-taken branches

The stalls introduced by each of these are assumed to be independent. (For example,
if a load is a cache miss followed by a load/use hazard, this assumes that both the
full cache miss penalty plus the full load/use hazard penalty must be taken,
even though maybe a processor could perhaps use clever forwarding to avoid the extra cycle
of load/use hazard penalty.)

Takes arguments:
    args: contains the command-line arguments passed to this program. If you want to
          support additional command line arguments, add new `add_argument` calls
          in main()
    fh: the file handle for the trace CSV file

Returns a dictionary containing:
    branch_delay: estimated delay from branch mispredictions
    load_use_delay: estimated delay from load_use hazards
    delay: total delay of all types
    cycles: total simualted cycles
    instructions: total instructions processed
"""
def count_time_in(args, fh):
    csv_reader = csv.DictReader(fh)

    # last instruction, for detecting load/use hazards
    last_instruction = None

    # number instructions processed
    num_instructions = 0

    # total cycles accounted to load/use hazards
    load_use_delay = 0

    # total cycles account to branch misprediction penalties
    branch_delay = 0

    # a dictionary to record the instructions that have been 
    # executed before and if they were successfull
    instruction_dict = {}
    for instruction in csv_reader:
        if last_instruction != None:
            forward_from_last = (
                last_instruction['dst'] != '' and
                last_instruction['dst'] in (instruction['srcA'], instruction['srcB'])
            )
            if args.split_execute and forward_from_last and last_instruction['is_memory_read'] == 'Y':
                load_use_delay += 1
            if args.load_use_hazard and forward_from_last and last_instruction['is_memory_read'] == 'Y':
                load_use_delay += 1

        
        branch_not_taken = instruction['branch_taken'] == 'N' or args.no_predict    
        if (not args.hist_branch) and instruction['is_conditional_branch'] == 'Y' and branch_not_taken:
            branch_delay += args.branch_delay
        if (args.hist_branch and instruction['is_conditional_branch'] == 'Y'):
            instruction_type = instruction['orig_pc']
            instruction_dict[instruction_type] = instruction_dict.setdefault(instruction_type, True)
            is_taken = instruction['branch_taken'] == 'Y'
            if is_taken != instruction_dict[instruction_type] :
                branch_delay += args.branch_delay
                instruction_dict[instruction_type] = is_taken


            

        last_instruction = instruction
        num_instructions += 1

    return {
        'load_use_delay': load_use_delay,
        'branch_delay': branch_delay,
        'delay': load_use_delay + branch_delay,
        'cycles': num_instructions + load_use_delay + branch_delay,
        'instructions': num_instructions,
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input', type=argparse.FileType('r'), metavar='INPUT-FILE')
    parser.add_argument('--enable-load-use-hazard', action='store_true', dest='load_use_hazard',
        help='enable simulated load/use hazard (default)',
        default=True,
    )
    parser.add_argument('--disable-load-use-hazard', action='store_false', dest='load_use_hazard',
        help='disable simulated load/use hazard'
    )
    parser.add_argument('--branch-delay', default=2, type=int, help='branch delay in cycles')
    parser.add_argument('--no-predict', default=False, action='store_true', dest='no_predict', help='disable conditional branch prediction')    
    parser.add_argument('--split-execute', default=False, action='store_true',dest='split_execute',
        help='simulates splitting the execute stage into multiple stages')
    parser.add_argument('--historical-branch-predict', default=False, action='store_true',
        dest='hist_branch', help='the program takes a branch if the instruction has been executed before' +
         'or it is the first time the instruction has been executed.')
    args = parser.parse_args()
    result = count_time_in(args, args.input)
    print("Total cycles", result['cycles'])
    print("Total instructions", result['instructions'])
    print("Total branch delay", result['branch_delay'])
    print("Total load/use hazard delay", result['load_use_delay'])
    print("Total delay", result['delay'])

if __name__ == '__main__':
    main()

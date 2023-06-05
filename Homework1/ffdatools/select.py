from argparse import ArgumentParser, Namespace
from datetime import datetime

def is_line_of_node(line: str, node: str):
    try:
        return line.split(' ')[2].strip().upper() == node.upper()
    except:
        return False

def main(args: Namespace):

    source_file = args.file
    node_name = args.node_name
    output_file = args.output_file or f'{node_name}_output'

    log_info('Starting selection of recors of node {} from file {}'.format(node_name, source_file))

    file_lines = open(source_file).readlines()
    with open(output_file, 'w') as f:
        for line in file_lines:
            if is_line_of_node(line, node_name):
                f.write(line)

    log_info('Finished. Output saved in file {}'.format(output_file))

def log_info(message: str):
    print(f'[INFO] - {datetime.now()} - {message}')

if __name__ == '__main__':
    ap = ArgumentParser()
    ap.add_argument('-f', '--file', help='File to parse',required=True)
    ap.add_argument('-n', '--node-name', help='Node to extract', required=True)
    ap.add_argument('-o', '--output-file', help='File to use to save results')

    args = ap.parse_args()
    main(args)
from argparse import ArgumentParser, Namespace
import os

def encode_nodes(file, old_res = {}) -> dict:
    lines = open(file, 'r').readlines()
    res: dict = old_res
    counter = 1
    if (res and res.values()):
        counter = max(res.values()) + 1
    for line in lines:
        node = line.split(' ')[2].strip()
        if not res.get(node):
            res[node] = counter
            counter += 1

    return res


def main(args: Namespace):

    source_folder = args.folder
    output_file = args.output_file or f'{source_folder}_output'

    tuples = [f for f in os.listdir(source_folder) if 'tuple-' in f]

    output = open(output_file, 'w')

    for file in tuples:
        tuple_file_path = os.path.join(source_folder, file)
        encoded_nodes_dict = encode_nodes(tuple_file_path)
        #print(encoded_nodes_dict)

        lines = open(tuple_file_path).readlines()

        node_set = set()
        for line in lines:
            node_set.add(str(encoded_nodes_dict.get(line.split(' ')[2].strip())))
            #node_set.add(line.split(' ')[2].strip())

        output.write(','.join(node_set) + '\n')
    
    output.close()


if __name__ == '__main__':
    ap = ArgumentParser()
    ap.add_argument('-f', '--folder', help='Folder to analyze',required=True)
    #ap.add_argument('-n', '--node-name', help='Node to extract', required=True)
    ap.add_argument('-o', '--output-file', help='File to use to save results')

    args = ap.parse_args()
    main(args)
#!/usr/bin/env python
# -*- coidng: utf-8

import sys

def main(args):
    print(args)

if __name__ == '__main__':
    run.warning('If you publish results from this workflow, please do not forget to cite snakemake '
                '(doi:10.1093/bioinformatics/bts480)', lc = 'yellow')

    from anvio.argparse import ArgumentParser
    parser = ArgumentParser(description=__description__)

    #add pargse arguments: https://github.com/merenlab/anvio/blob/master/bin/anvi-run-workflow

    args = parser.get_args(parser)

    try:
        main(args)
    except ConfigError as e:
        print(e)
        sys.exit(-1)
    except FilesNPathsError as e:
        print(e)
        sys.exit(-2)
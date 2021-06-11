# -*- coding: utf-8 -*-
"""Hello World for Pytorch!"""
__author__ = "michael.smith@qs-2.com"

import logging
from argparse import ArgumentParser

import torch

# declare and set up logger – useful on AWS CloudWatch instead of 'print' calls
logging.basicConfig(
    format='%(asctime)s: %(levelname)s (%(name)s) - %(message)s',
    level=logging.INFO,
    datefmt='%m/%d/%Y %H:%M:%S')

logger = logging.getLogger(__name__)


def main(my_int, raise_error=False, silly_size_limit=10):
    """Silly little method to check CUDA's availability and use it in a pytorch tensor"""
    using_cuda = torch.cuda.is_available()  # check if we can use CUDA
    logger.info(f"torch.cuda.is_available: {using_cuda}")  # should print True
    if not using_cuda and raise_error:
        raise ValueError('cuda unavailable!')
    if my_int > silly_size_limit:
        my_int = silly_size_limit
        logger.warning(f"size too big for a silly little example. defaulting to `{silly_size_limit}`")
    logger.info(f"{torch.rand(my_int).to('cuda' if using_cuda else 'cpu')}")  # log a random tensor to ensure we’re good


if __name__ == "__main__":
    parser = ArgumentParser(description="hello to pytorch! test with cuda.is_available and torch.rand().to(...)")
    parser.add_argument("rand_int_size", type=int, help="pass this integer to `torch.rand()` and convert to tensor")
    parser.add_argument("-r", "--raise-error", action='store_true',
                        help="if given, raise an error on failure to use GPU, otherwise use CPU")
    args = parser.parse_args()
    main(args.rand_int_size, raise_error=args.raise_error)

# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved

import black
import bokeh
import bqplot
import cookiecutter
import dask
import dask_jobqueue
import dask_labextension
import datashader
import distributed
import dotenv
import flake8
import ipywidgets
import isort
import jupyter
import jupyter_client
import jupyter_server_proxy
import jupyterlab
import nbformat
import nbgitpuller
import numba
import numexpr
import numpy
import matplotlib
import pandas
import papermill
import pipdeptree
import plotly
import pre_commit
import pylint
import pyscaffold
import pytest
import pytest_cov
import schema
import scipy
import seaborn
import setuptools
import statsmodels
import stl
import tables
import termcolor
import virtualenv
import voila
import xarray

from dask.distributed import Client, progress
client = Client(processes=False, threads_per_worker=1,
                n_workers=1, local_directory="/tmp")
import dask.array as da
x = da.random.random((10000, 10000), chunks=(1000, 1000))
y = x + x.T
z = y[::2, 5000:].mean(axis=1)
z.compute()

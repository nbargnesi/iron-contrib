gosh-contrib
============

A collection of scripts for `the go shell`_.

.. _the go shell: https://github.com/formwork-io/gosh

**This is free software with ABSOLUTELY NO WARRANTY.**

.. image:: https://travis-ci.org/formwork-io/gosh-contrib.svg?branch=master
    :target: https://travis-ci.org/formwork-io/gosh-contrib

.. contents::


Python
------

create_python_env
+++++++++++++++++
Creates a virtual environment for a specific Python interpreter and dependency
set.

.. code:: bash

    default GOSH_CONTRIB_PYTHON_VIRTUALENV "/path/to/virtualenv.py"
    default GOSH_CONTRIB_PYTHON_REQ_DEPS   "/path/to/deps.req"
    default GOSH_CONTRIB_PYTHON_OPT_DEPS   "/path/to/deps.opt"
    default GOSH_CONTRIB_PYTHON_VENV       "/path/to/python-env"
    create_python_env "python3"

Node
----

create_node_env
+++++++++++++++
Creates ``node_modules`` from ``package.json`` and adds its ``.bin`` directory
to the ``PATH``.

.. code:: bash

    default GOSH_CONTRIB_NODE_NPM_PKGJSON "/path/nodeenv1/package.json"
    default GOSH_CONTRIB_NODE_NPM_MODPATH "/path/nodeenv1"
    create_node_env

Ruby
----

create_gem_path
+++++++++++++++
Creates a gem path from a Gemfile and adds its ``bin`` directory to the
``PATH``

.. code:: bash

    default GOSH_CONTRIB_RUBY_GEMPATH "/path/to/gems"
    default GOSH_CONTRIB_RUBY_GEMFILE "/path/to/Gemfile"
    create_gem_path

ESLint
------

create_eslint_env
+++++++++++++++++

TODO


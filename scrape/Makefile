# Black magic to get module directories
modules := $(foreach initpy, $(foreach dir, $(wildcard *), $(wildcard $(dir)/__init__.py)), $(realpath $(dir $(initpy))))

.PHONY: all
all: setup requirements develop pylint pytest

setup:
	pip install pip-tools

install_requirements.txt: install_requirements.in
	pip-compile install_requirements.in

requirements.txt: requirements.in install_requirements.txt
	pip-compile requirements.in

requirements: requirements.txt install_requirements.txt
	pip install -r requirements.txt

develop:
	python setup.py develop

install:
	python setup.py install

pylint:
	# linting via http://flake8.pycqa.org/en/latest/
	flake8 $(modules) tests/

pytest:
	# testing + code coverage via https://docs.pytest.org/en/latest/usage.html
	PYTHONPATH=. pytest -v -l --doctest-modules $(foreach dir,$(modules),--cov=$(dir)) --cov-report=term-missing tests/ $(modules)

clean:
	rm -rf .cache  .coverage build dist  .eggs *.egg-info .pytest_cache
	find . -name '*.pyc' -type f -delete
	find . -name __pycache__ -type d -delete

release:
	python setup.py bdist_wheel

#=============================================================================
# FILE: look.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
#=============================================================================

from os.path import expanduser, expandvars
import re
import subprocess
from .base import Base

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'look'
        self.mark = '[look]'
        self.min_pattern_length = 4

        def get_look_var(shortname, default):
            return vim.vars.get('deoplete#look#{}'.format(shortname), default)

        self.is_volatile = True

        self.executable_look = self.vim.call('executable', 'look')
        self.words = get_look_var('words', None)
        if self.words:
            self.words = expandvars(expanduser(self.words))

    def _query_look(self, querystring):
        command = ['look', querystring]

        if self.words is not None:
            command.append(self.words)

        return subprocess.check_output(command).splitlines()

    def gather_candidates(self, context):
        if not self.executable_look:
            return []

        try:
            # We're adding :2 here to support head prefixed fuzzy search
            # "look" will return some results and deoplete will fuzzy search in
            # the rest.
            words = [
                x.decode(context['encoding'], errors='ignore')
                for x in self._query_look(context['complete_str'][:2])
            ]
        except subprocess.CalledProcessError:
            return []
        if re.match('[A-Z][a-z0-9_-]*$', context['complete_str']):
            words = [x[0].upper() + x[1:] for x in words]
        elif re.match('[A-Z][A-Z0-9_-]*$', context['complete_str']):
            words = [x.upper() for x in words]

        return [{ 'word': x } for x in words]

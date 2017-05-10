#=============================================================================
# FILE: look.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
#=============================================================================

import os
import re
import subprocess
from .base import Base

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'look'
        self.mark = '[look]'

        def get_look_var(shortname, default):
            return vim.vars.get('deoplete#look#{}'.format(shortname), default)

        self.is_volatile = True

        self.executable_look = self.vim.call('executable', 'look')
        self.words_source = get_look_var('words_source', None)
        if self.words_source:
            self.words_source = os.path.expanduser(self.words_source)

    def _query_look(self, querystring):
        command = ['look', querystring]

        if self.words_source is not None:
            command.append(self.words_source)

        return subprocess.check_output(command).splitlines()

    def gather_candidates(self, context):
        if not self.executable_look:
            return []

        try:
            words = [
                    x.decode(context['encoding'])
                    for x in self._query_look(context['complete_str'])
                    ]
        except subprocess.CalledProcessError:
            return []
        if re.match('[A-Z][a-z0-9_-]*$', context['complete_str']):
            words = [x[0].upper() + x[1:] for x in words]
        elif re.match('[A-Z][A-Z0-9_-]*$', context['complete_str']):
            words = [x.upper() for x in words]

        return [{ 'word': x } for x in words]

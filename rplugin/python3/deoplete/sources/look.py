#=============================================================================
# FILE: look.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
#=============================================================================

import re
import subprocess
from .base import Base

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'look'
        self.mark = '[look]'
        self.min_pattern_length = 4
        self.executable_look = self.vim.call('executable', 'look')
        self.is_volatile = True

    def gather_candidates(self, context):
        if not self.executable_look:
            return []

        try:
            words = [x.decode(context['encoding']) for x in
                     subprocess.check_output(
                         ['look', context['complete_str']]).splitlines()]
        except subprocess.CalledProcessError:
            return []
        if re.match('[A-Z][a-z0-9_-]*$', context['complete_str']):
            words = [x[0].upper() + x[1:] for x in words]
        elif re.match('[A-Z][A-Z0-9_-]*$', context['complete_str']):
            words = [x.upper() for x in words]

        return [{ 'word': x } for x in words]

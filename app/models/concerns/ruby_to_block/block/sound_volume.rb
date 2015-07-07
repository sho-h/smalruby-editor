# -*- coding: utf-8 -*-
module RubyToBlock
  module Block
    class SoundVolume < Value
      blocknize '^\s*volume\s*$', value: true
    end
  end
end

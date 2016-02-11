# -*- coding: utf-8 -*-
require 'spec_helper'
require_relative 'shared/block_examples'

# rubocop:disable EmptyLines, LineLength

describe RubyToBlock::Block, '音ジャンル', to_blocks: true do
  parts = <<-EOS
car1.on(:start) do
  self.volume = 100
  play(name: "piano_do.wav")
  p(volume)
end
car1.play(name: "piano_do.wav")
car1.volume = 100
p(car1.volume)
  EOS
  describe compact_source_code(parts), character_new_data: true do
    _parts = parts
    let(:parts) { _parts }

    it '結果が正しいこと' do
      should eq_block_xml(<<-XML)
    <field name="NAME">car1</field>
    <statement name="DO">
      <block type="events_on_start">
        <statement name="DO">
          <block type="sound_set_volume" inline="true">
            <value name="VOLUME">
              <block type="math_number">
                <field name="NUM">100</field>
              </block>
            </value>
            <next>
              <block type="sound_play" inline="true">
                <value name="NAME">
                  <block type="sound_preset_sounds">
                    <field name="NAME">piano_do.wav</field>
                  </block>
                </value>
                <next>
                  <block type="ruby_p" inline="true">
                    <value name="ARG">
                      <block type="sound_volume" />
                    </value>
                  </block>
                </next>
              </block>
            </next>
          </block>
        </statement>
        <next>
          <block type="sound_play" inline="true">
            <value name="NAME">
              <block type="sound_preset_sounds">
                <field name="NAME">piano_do.wav</field>
              </block>
            </value>
            <next>
              <block type="sound_set_volume" inline="true">
                <value name="VOLUME">
                  <block type="math_number">
                    <field name="NUM">100</field>
                  </block>
                </value>
                <next>
                  <block type="ruby_p" inline="true">
                    <value name="ARG">
                      <block type="ruby_expression">
                        <field name="EXP">car1.volume</field>
                      </block>
                    </value>
                  </block>
                </next>
              </block>
            </next>
          </block>
        </next>
      </block>
    </statement>
      XML
    end
  end
end

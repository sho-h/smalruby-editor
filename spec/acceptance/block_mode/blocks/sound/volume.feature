# encoding: utf-8
# language: ja
@javascript
機能: sound_volume - 「音量」ブロック
  背景:
    前提 "ブロック" タブを表示する

  シナリオ: ブロックを配置する
    もし 次のブロックを配置する:
      """
      %block{:type => "sound_volume", :x => "0", :y => "0", :inline => "true"}
      """
    かつ ブロックからソースコードを生成する

    ならば テキストエディタのプログラムは以下を含むこと:
      """
      volume
      """

    もし 次のブロックを配置する:
      """
      %block{:type => "ruby_p", :x => "0", :y => "0", :inline => "true"}
        %value{:name => "ARG"}
          %block{:type => "sound_volume"}
      """
    かつ ブロックからソースコードを生成する

    ならば テキストエディタのプログラムは以下を含むこと:
      """
      p(volume)
      """

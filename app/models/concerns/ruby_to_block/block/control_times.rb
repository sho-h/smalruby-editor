module RubyToBlock
  module Block
    class ControlTimes < Base
      blocknize '^\s*(.+)\.times\s+do\s*$', statement: true, indent: true

      def self.process_match_data(md, context)
        return false unless context.receiver
        md2 = regexp.match(md[type])

        do_block = Block.new('null')
        block = new(statements: { DO: do_block })
        process_value_string(context, block, md2[1], :COUNT)
        context.statement_stack.push([type, block])
        context.current_block.sibling = block
        context.current_block = do_block
        true
      end
    end
  end
end

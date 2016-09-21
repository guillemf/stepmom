module Stepmom
  module Parser
    class Step
      KEYWORD_LIST = {
        /given(.*)/i  => :Given,
        /when(.*)/i   => :When,
        /then(.*)/i   => :Then,
        /and(.*)/i    => :And,
        /but(.*)/i    => :But,
      }
      attr_reader :definition,
                  :tokens
      def initialize(description)
        return unless description.length > 0

        matches = /[\/][\^](.*)[\$][\/]/.match(description)
        if matches != nil && matches.length > 0
          @definition = matches[1]
          @tokens = []
          
          # Extract keyword, if any as first token
          Step::KEYWORD_LIST.each do |regex, keyword| 
            if regex.match(description)
              newKeyWord = [:keyword, keyword]
              @tokens.insert(-1, newKeyWord)
              break
            end
          end
          # No Keywords means this is not a step definition
          return unless @tokens.count > 0
          
          # Avoid \" that could devirtuate parameter regex
          tmpDefinition = @definition.gsub("^\\\"", "^\\™")
          paramList = /[\"]([^\"]*)[\"]/.match(tmpDefinition)

          # Process step with no params
          if !paramList
            newText = [:text, tmpDefinition.strip]
            @tokens.insert(@tokens.length, newText)
            return
          end
          
          paramList[0..paramList.length-1].each do |aParam|
            paramPosition = tmpDefinition.index(aParam)
            
            # Extract text between params
            if paramPosition > 0
              newText = [:text, tmpDefinition[0..paramPosition-2].strip]
              @tokens.insert(@tokens.length, newText)
              tmpDefinition = tmpDefinition[paramPosition..tmpDefinition.length]
            end
            # Extract param content
            tmpDefinition = tmpDefinition[aParam.length..tmpDefinition.length]
            preFormattedParam = aParam.gsub('"', '').strip
            newToken = [:argument, preFormattedParam.gsub!('™', '"')]
            @tokens.insert(@tokens.length, newToken)
            if tmpDefinition.length == 0 
              break
            end
          end
        end
      end
      
      def format(flags)
        if @tokens
          flat_tokens = @tokens.map { |token| token[1] }
          formattedTokens = ""
          flat_tokens.each { |token| formattedTokens += "#{token}\t" }
          formattedTokens.strip
          # remove last tab
          formattedTokens[0..formattedTokens.length-2]
        end
      end
    end
    class StepsFile
      def self.getSteps(filePath)
        steps = []
        File.open(File.expand_path(filePath)).each do |line|
          newStep = Stepmom::Parser::Step.new(line)
          if newStep.tokens
            steps.push newStep
          end
        end
        return steps
      end
    end
  end
end

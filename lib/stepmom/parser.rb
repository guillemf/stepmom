require 'rainbow'
require 'damerau-levenshtein'

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
      PARAMETERS_LIST = [
        /([(][\[][\^][™][\]][*][)])/,
        /([(] ?[\.][(+|*)] ?[)][\?]?)/,
        /[(][\\][d][+][)]/
      ]  
      FORMAT_FLAGS = [
        :showPath,
        :showFile,
        :showKeyword
      ]
      
      attr_reader :definition,
                  :tokens
      attr_accessor :fileInfo
      
      def initialize(description)
        #initialize file info always
        @fileInfo = {}
        
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
          tmpDefinition = @definition.gsub("\^\"", "\^™")
          paramList = []
          Step::PARAMETERS_LIST.each do |expression|
            # expression.match(tmpDefinition)
            newParamList = tmpDefinition.scan(expression).map do |match|
              if match.class == Array
                match[0]
              else
                match
              end
            end
            paramList.push(*newParamList)
          end
          
          # Process step with no params
          if paramList.count == 0
            newText = [:text, tmpDefinition.strip]
            @tokens.insert(@tokens.length, newText)
            return
          end
          
          paramList[0..paramList.length-1].each do |aParam|

            paramPosition = tmpDefinition.index(aParam)
            # Extract text between params
            if paramPosition > 0
              newText = [:text, tmpDefinition[0..paramPosition-1]]
              @tokens.insert(@tokens.length, newText)
            end
            tmpDefinition = tmpDefinition[(paramPosition + aParam.length)..tmpDefinition.length]
            newToken = [:argument, aParam.gsub("\^™", "\^\"").strip]
            @tokens.insert(@tokens.length, newToken)
            if tmpDefinition.length == 0 
              break
            end
          end
          if tmpDefinition.length > 0
            newText = [:text, tmpDefinition]
            @tokens.insert(@tokens.length, newText)
          end 
        end
      end
      
      def format(flags)
        if @tokens
          formattedTokens = ""
          if flags.include?(:showFile)            
            if fileInfo[:path]
              truncatedFileName = File.basename(fileInfo[:path])[0..19]
              formattedTokens = Rainbow(truncatedFileName + (" " * (20 - truncatedFileName.length)) + "\t").color(:khaki)
            else
              formattedTokens = " " * 20 + "\t"
            end
          end
          
          @tokens.each do |token| 
            formattedTokens += case token[0]
            when :keyword
              if flags.include?(:showKeyword)
                Rainbow("#{token[1]}").green + "\t"
              else
                ""
              end
            when :argument
              Rainbow("#{token[1]}").red
            else
              "#{token[1]}"
            end
          end
          formattedTokens.strip
          # remove last tab
          if formattedTokens[formattedTokens.length-1] == '\t'
            formattedTokens = formattedTokens[0..formattedTokens.length-1]
          end
          return formattedTokens
        end
      end
      
      def distance(step)
        selfTexts = self.text
        stepTexts = step.text
        
        return stepTexts.length unless selfTexts != ''
        return 0 unless selfTexts != stepTexts 
                
        selfRegex = /#{Regexp.escape(selfTexts.strip.downcase)}/i
        stepRegex = /#{Regexp.escape(stepTexts.strip.downcase)}/i
        if selfRegex.match(stepTexts) || stepRegex.match(selfTexts)
          return 1
        end
        dl = DamerauLevenshtein
        return dl.distance(selfTexts, stepTexts, 2)
      end
      
      def text
        text = ""
        self.tokens.each { |x| text += " " + x[1].strip if x[0] == :text } unless self.tokens.nil?
        return text.strip
      end
      
      def match(text)
        checkExpr = /#{Regexp.new(self.definition.strip.downcase)}/i
        return !checkExpr.match(text.downcase).nil?
      end
    end
    class StepsFile
      
      def self.getSteps(filePath)
        steps = []
        File.open(File.expand_path(filePath)).each do |line|          
          newStep = Stepmom::Parser::Step.new(line)
          newStep.fileInfo[:path] = filePath
          if newStep.tokens
            steps.push newStep
          end
        end
        return steps
      end
      
      def self.getInfo(filePath, steps)
        return { 
          :fileName   => File.basename(filePath),
          :lastAcces  => File.mtime(filePath),
          :fileSize   => File.size(filePath),
          :stepCount  => steps.count
        }
      end
      
      def self.format(fileInfo)
        fileName = Rainbow("File name:\t").color(:royalblue) + Rainbow("#{fileInfo[:fileName]}").white
        todayFormatted = fileInfo[:lastAcces].strftime("%Y-%m-%d")
        fileTime = Rainbow("Last updated:\t").color(:royalblue) + Rainbow("#{todayFormatted}").white
        fileSize = Rainbow("Size:\t\t").color(:royalblue) + Rainbow("#{fileInfo[:fileSize]}").white + " bytes"
        fileSteps= Rainbow("Steps:\t\t").color(:royalblue) + Rainbow("#{fileInfo[:stepCount]}").white + " steps"
        <<FORMAT_INFO
#{fileName}
#{fileTime}
#{fileSize}
#{fileSteps}
FORMAT_INFO
      end
    end
  end
end

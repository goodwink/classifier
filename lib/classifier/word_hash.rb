# coding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

# These are extensions to the String class to provide convenience
# methods for the Classifier package.
# 
# This class wraps Hash instead of adding methods to String, to avoid
# extending the core class too much.

require 'lingua/stemmer'

module Classifier
  
  class WordHash < Hash

    attr_accessor :stemmer
    # Create a hash of strings => ints. Each word in the string is stemmed
    # and indexed to its frequency in the document.
    #
    # clean_source (bool):
    #   Return a word hash without extra punctuation or short symbols,
    #   just stemmed words
    def initialize(source, options = {})
      super()
      options = {
        :clean_source => true,
        :stemmer_language => 'en'
      }.merge(options)
      language = options[:stemmer_language]
      @stemmer = Lingua::Stemmer.new(:language => language)
      @skip_words = CORPUS_SKIP_WORDS[language] || []
      populate_with( options[:clean_source] ?
        strip_punctuation(source).gsub(/[^\w\s]/,"").split :
        source.gsub(/[^\w\s]/,"").split + source.gsub(/[\w]/," ").split
      )
    end
    
    
    private
    
    def populate_with( words )
      words.each do |word|
        word.downcase! if word =~ /[\w]+/
        if valid?( word )
          key = self.stemmer.stem(word)
          self[key] ||= 0
          self[key] += 1
        end
      end
    end
    
    # Removes common punctuation symbols, returning a new string.
    # E.g.,
    #   "Hello (greeting's), with {braces} < >...?".without_punctuation
    #   => "Hello  greetings   with  braces         "
    def strip_punctuation( s )
      s.tr( ',?.!;:"@#$%^&*()_=+[]{}\|<>/`~', " " ).tr( "'\-", "")
    end
    
    # Test if the string contains letters AND numbers.
    def mixed_alphanumeric?( s )
      !!((s=~/^[A-z]/ && s.index(/[0-9]/)) || (s=~/^\d/ && s.index(/[A-z]/)))
    end
    
    def valid?( s )
      s =~ /[^\w]/ ||
      ! @skip_words.include?(s) &&
      s.length > 2 &&
      ! mixed_alphanumeric?(s)
    end

    CORPUS_SKIP_WORDS = {
      'en' => [
        "a",
        "again",
        "all",
        "along",
        "are",
        "also",
        "an",
        "and",
        "as",
        "at",
        "but",
        "by",
        "came",
        "can",
        "cant",
        "couldnt",
        "did",
        "didn",
        "didnt",
        "do",
        "doesnt",
        "dont",
        "ever",
        "first",
        "from",
        "have",
        "her",
        "here",
        "him",
        "how",
        "i",
        "if",
        "in",
        "into",
        "is",
        "isnt",
        "it",
        "itll",
        "just",
        "last",
        "least",
        "like",
        "most",
        "my",
        "new",
        "no",
        "not",
        "now",
        "of",
        "on",
        "or",
        "should",
        "sinc",
        "so",
        "some",
        "th",
        "than",
        "this",
        "that",
        "the",
        "their",
        "then",
        "those",
        "to",
        "told",
        "too",
        "true",
        "try",
        "until",
        "url",
        "us",
        "were",
        "when",
        "whether",
        "while",
        "with",
        "within",
        "yes",
        "you",
        "youll"
      ],
      'es' => [
        "de",
        "la",
        "que",
        "el",
        "en",
        "y",
        "a",
        "los",
        "del",
        "se",
        "las",
        "por",
        "un",
        "para",
        "con",
        "no",
        "una",
        "su",
        "al",
        "lo",
        "como",
        "más",
        "pero",
        "sus",
        "le",
        "ya",
        "o",
        "este",
        "sí",
        "porque",
        "esta",
        "entre",
        "cuando",
        "muy",
        "sin",
        "sobre",
        "también",
        "me",
        "hasta",
        "hay",
        "donde",
        "quien",
        "desde",
        "todo",
        "nos",
        "durante",
        "todos",
        "uno",
        "les",
        "ni",
        "contra",
        "otros",
        "ese",
        "eso",
        "ante",
        "ellos",
        "e",
        "esto",
        "mí",
        "antes",
        "algunos",
        "qué",
        "unos",
        "yo",
        "otro",
        "otras",
        "otra",
        "él",
        "tanto",
        "esa",
        "estos",
        "mucho",
        "quienes",
        "nada",
        "muchos",
        "cual",
        "poco",
        "ella",
        "estar",
        "estas",
        "algunas",
        "algo",
        "nosotros",
        "mi",
        "mis",
        "tú",
        "te",
        "ti",
        "tu",
        "tus",
        "ellas",
        "nosotras",
        "vosotros",
        "vosotras",
        "os",
        "mío",
        "mía",
        "míos",
        "mías",
        "tuyo",
        "tuya",
        "tuyos",
        "tuyas",
        "suyo",
        "suya",
        "suyos",
        "suyas",
        "nuestro",
        "nuestra",
        "nuestros",
        "nuestras",
        "vuestro",
        "vuestra",
        "vuestros",
        "vuestras",
        "esos",
        "esas",
        "estoy",
        "estás",
        "está",
        "estamos",
        "estáis",
        "están",
        "esté",
        "estés",
        "estemos",
        "estéis",
        "estén",
        "estaré",
        "estarás",
        "estará",
        "estaremos",
        "estaréis",
        "estarán",
        "estaría",
        "estarías",
        "estaríamos",
        "estaríais",
        "estarían",
        "estaba",
        "estabas",
        "estábamos",
        "estabais",
        "estaban",
        "estuve",
        "estuviste",
        "estuvo",
        "estuvimos",
        "estuvisteis",
        "estuvieron",
        "estuviera",
        "estuvieras",
        "estuviéramos",
        "estuvierais",
        "estuvieran",
        "estuviese",
        "estuvieses",
        "estuviésemos",
        "estuvieseis",
        "estuviesen",
        "estando",
        "estado",
        "estada",
        "estados",
        "estadas",
        "estad",
        "he",
        "has",
        "ha",
        "hemos",
        "habéis",
        "han",
        "haya",
        "hayas",
        "hayamos",
        "hayáis",
        "hayan",
        "habré",
        "habrás",
        "habrá",
        "habremos",
        "habréis",
        "habrán",
        "habría",
        "habrías",
        "habríamos",
        "habríais",
        "habrían",
        "había",
        "habías",
        "habíamos",
        "habíais",
        "habían",
        "hube",
        "hubiste",
        "hubo",
        "hubimos",
        "hubisteis",
        "hubieron",
        "hubiera",
        "hubieras",
        "hubiéramos",
        "hubierais",
        "hubieran",
        "hubiese",
        "hubieses",
        "hubiésemos",
        "hubieseis",
        "hubiesen",
        "habiendo",
        "habido",
        "habida",
        "habidos",
        "habidas",
        "soy",
        "eres",
        "es",
        "somos",
        "sois",
        "son",
        "sea",
        "seas",
        "seamos",
        "seáis",
        "sean",
        "seré",
        "serás",
        "será",
        "seremos",
        "seréis",
        "serán",
        "sería",
        "serías",
        "seríamos",
        "seríais",
        "serían",
        "era",
        "eras",
        "éramos",
        "erais",
        "eran",
        "fui",
        "fuiste",
        "fue",
        "fuimos",
        "fuisteis",
        "fueron",
        "fuera",
        "fueras",
        "fuéramos",
        "fuerais",
        "fueran",
        "fuese",
        "fueses",
        "fuésemos",
        "fueseis",
        "fuesen",
        "siendo",
        "sido",
        "tengo",
        "tienes",
        "tiene",
        "tenemos",
        "tenéis",
        "tienen",
        "tenga",
        "tengas",
        "tengamos",
        "tengáis",
        "tengan",
        "tendré",
        "tendrás",
        "tendrá",
        "tendremos",
        "tendréis",
        "tendrán",
        "tendría",
        "tendrías",
        "tendríamos",
        "tendríais",
        "tendrían",
        "tenía",
        "tenías",
        "teníamos",
        "teníais",
        "tenían",
        "tuve",
        "tuviste",
        "tuvo",
        "tuvimos",
        "tuvisteis",
        "tuvieron",
        "tuviera",
        "tuvieras",
        "tuviéramos",
        "tuvierais",
        "tuvieran",
        "tuviese",
        "tuvieses",
        "tuviésemos",
        "tuvieseis",
        "tuviesen",
        "teniendo",
        "tenido",
        "tenida",
        "tenidos",
        "tenidas",
        "tened"
      ]
    }
  end
  
end
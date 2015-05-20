require "hashie/mash"
require "mighty_struct"
require "pry"
require_relative "../mighty_struct"

class Benchmark::MightyStruct::MightyStructVersusOthers
  def call
    hash = {
      a: 1,
      b: {
        c: 2,
        "d" => 3,
        e: [
          {
            f: 4
          }
        ]
      }
    }

    puts "\n"

    Benchmark.ips do |x|
      puts "Hashie::Mash.new(hash)"
      puts "MightyStruct.new(hash)"
      puts "OpenStruct.new(hash)"
      puts "\n"

      x.report("Hashie::Mash") { Hashie::Mash.new(hash) }
      x.report("MightyStruct") { MightyStruct.new(hash) }
      x.report("OpenStruct") { OpenStruct.new(hash) }

      x.compare!
    end

    [:enabled, :disabled].each do |_caching_mode|
      puts "Hashie::Mash.new(hash).b.c"
      puts "MightyStruct.new(hash, caching: :#{_caching_mode}).b.c"
      puts "OpenStruct.new(hash).b.c"
      puts "\n"

      Benchmark.ips do |x|
        hashie_mash = Hashie::Mash.new(hash)
        mighty_struct = MightyStruct.new(hash, caching: _caching_mode)
        open_struct = OpenStruct.new(hash)
        open_struct.b = OpenStruct.new(open_struct.b)

        if hashie_mash.b.c != hash[:b][:c] || mighty_struct.b.c != hash[:b][:c] || open_struct.b.c != hash[:b][:c]
          raise
        end

        x.report("Hashie::Mash") { hashie_mash.b.c }
        x.report("MightyStruct") { mighty_struct.b.c }
        x.report("OpenStruct") { open_struct.b.c }

        x.compare!
      end
    end
  end
end

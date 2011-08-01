module AudioFixtures
  def with_mp3_file(attr, &blk)
    @file = Tempfile.new ['castle-test-', '.mp3']
    system("dd if=/dev/urandom bs=44100 count=4 2>/dev/null | " +
            "lame -r --bitwidth 16 -m j -s 44.1 " +
            "--preset cbr 128 " +
            "--tt #{@attrs[:title]} --ta #{@attrs[:artist]} --tl #{@attrs[:album]} --ty #{@attrs[:date]} --tn #{@attrs[:tracknum]} " +
            "- #{@file.path} 2>/dev/null")  or raise $!
    @file.open
    blk.call(@file.path)
    @file.close
  end

  def with_ogg_file(attr, &blk)
    @file = Tempfile.new ['castle-test-', '.ogg']
    system("dd if=/dev/urandom bs=44100 count=4 2>/dev/null | " +
            "oggenc -r -B 16 -C 2 -R 44100 " +
            "-m 128 -M 128 " +
            "-t #{@attrs[:title]} -a #{@attrs[:artist]} -l #{@attrs[:album]} -d #{@attrs[:date]} -N #{@attrs[:tracknum]} " +
            "-o #{@file.path} - 2>/dev/null") or raise $!
    @file.open
    blk.call(@file.path)
    @file.close
  end
end
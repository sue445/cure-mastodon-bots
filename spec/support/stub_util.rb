module StubUtil
  def read_stub(filename)
    spec_dir.join("stubs", filename).read
  end
end

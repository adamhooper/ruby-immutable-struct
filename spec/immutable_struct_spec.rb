require_relative '../lib/ruby-immutable-struct'

describe RubyImmutableStruct do
  describe 'with a typical struct' do
    before(:each) do
      @struct = RubyImmutableStruct.new(:foo, :bar)
    end

    it 'should construct by hash' do
      v = @struct.new(foo: 'FOO1', bar: 'BAR1')
      expect(v.foo).to eq('FOO1')
      expect(v.bar).to eq('BAR1')
    end

    it 'should construct by argument list' do
      v = @struct.new('FOO2', 'BAR2')
      expect(v.foo).to eq('FOO2')
      expect(v.bar).to eq('BAR2')
    end

    it 'should have a to_h method' do
      expect(@struct.new('foo3', 'bar3').to_h).to eq(foo: 'foo3', bar: 'bar3')
    end

    it 'should have a to_a method' do
      expect(@struct.new('foo4', 'bar4').to_a).to eq([ 'foo4', 'bar4' ])
    end
  end

  describe '#merge' do
    before(:each) do
      @struct = RubyImmutableStruct.new(:a, :b, :c)
      @obj1 = @struct.new('A1', 'B1', 'C1')
    end

    it 'should override something' do
      expect(@obj1.merge(b: 'B2').b).to eq('B2')
    end

    it 'should keep previous values when no override is given' do
      expect(@obj1.merge(b: 'B2').a).to eq('A1')
    end

    it 'should not change anything on the original' do
      @obj1.merge(b: 'B2')
      expect(@obj1.b).to eq('B1')
    end
  end

  it 'should allow user-specified methods' do
    struct = RubyImmutableStruct.new(:a) do
      def b; a.reverse; end
    end
    expect(struct.new('abc').b).to eq('cba')
  end

  it 'should allow access to class attributes within user-specified methods' do
    struct = RubyImmutableStruct.new(:a) do
      def b; @a.reverse; end
    end
    expect(struct.new('abc').b).to eq('cba')
  end

  it 'should not allow modifying class attributes within user-specified methods' do
    struct = RubyImmutableStruct.new(:a) do
      def b!; @a = 'foo'; end
    end
    expect { struct.new('abc').b! }.to raise_error(RuntimeError)
  end

  it 'should inspect properly' do
    SomeStruct = RubyImmutableStruct.new(:a, :b)
    expect(SomeStruct.new('A', 'B').inspect).to eq('#<SomeStruct "A","B">')
  end
end

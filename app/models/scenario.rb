class Scenario
  attr_accessor :side, :range, :market_type

  def initialize(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each { |k,v| send("#{k}=",v) }
    end
  end

  def back?
    @side == 'BACK'
  end

  def lay?
    @side == 'LAY'
  end

  def lay_sp?
    @side == 'LAY (SP)'
  end

  def size
    @size
  end

  def size=(size)
    @size = size.to_i
  end

  def position
    @position
  end

  def position=(pos)
    @position = pos.class == String ? pos.split(',').map{|p| p.strip.to_i - 1} : [pos.to_i - 1]
  end

  def positions(size)
    @range.blank? ? position.select{|p| p < size} : positions_from_range(size)
  end

  private

  def positions_from_range(size)
    if range == 'ALL'
      (0..(size - 1)).to_a
    elsif range == 'TOP 1/2'
      (0..((size * 0.5).round - 1)).to_a
    elsif range == 'BOTTOM 1/2'
      ((size * 0.5).round..size-1).to_a
    elsif range == 'TOP 1/3'
      (0..((size * 0.33).round - 1)).to_a
    elsif range == 'BOTTOM 1/3'
      ((size * 0.66).round..size - 1).to_a
    else
      raise "UNKNOWN range: #{range}"
    end
  end
end

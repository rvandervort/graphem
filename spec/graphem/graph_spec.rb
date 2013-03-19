require 'spec_helper.rb'

describe Graph do
  let(:graph) { described_class.new}
  before :each do
    graph.add_node :a, "A"
    graph.add_node :b, "B"
    graph.add_node :c, "C"
    graph.add_node :e, "E"
    graph.add_node :f, "F"

    graph.add_edge :a, :b
    graph.add_edge :a, :c
    graph.add_edge :c, :f
    graph.add_edge :b, :e 
  end

  describe ".[]" do
    it "returns the node with the passed key" do
      graph[:a].should eq("A")
    end
    
    it "returns nil if the node doesn't exist" do
      graph[:d].should be_nil
    end
  end

  describe ".add_edge(tail, edge, weight)" do
    it "adds the edge to the list" do
      expect { graph.add_edge :a, :c, 42}.to change { graph.instance_variable_get(:@edges)[:a][:c] }.to(42)
    end

    it "throws an InvalidNode exception if the tail is not an existing node in the graph" do
      expect { graph.add_edge(:d, :a, 12) }.to raise_error(InvalidNode)
    end

    it "throws an InvalidNode exception if the head is not an existing node in the graph" do
      expect { graph.add_edge(:a,:d, 12) }.to raise_error(InvalidNode)
    end
  end

  describe ".add_node" do
    it "adds the node to the list" do
      expect { graph.add_node :z, "Z" }.to change { graph[:z] }.to("Z")
    end
    it "initializes an empty list of edges" do
      expect { graph.add_node :z, "Z" }.to change { graph.instance_variable_get(:@edges)[:z] }.to({})
    end
  end

  describe ".backtrace" do
    let(:hierarchy) { {:d => :c, :c => :b, :e => :b, :b => :a } } 
    it "returns an array representing the hierarchy" do
      graph.backtrace(hierarchy, :d).should eq([:a, :b, :c, :d])
    end
  end

  describe ".bfs" do 
    it "returns the backtrace if the search for node can be reached" do
      graph.should_receive(:backtrace)
      graph.bfs(:a, :e)
    end

    it "returns nil if the searched for node cannot be reached from the start node" do
      graph.bfs(:b, :c).should be_nil
    end
  end

  describe ".validate_node" do
    it "raises an exception if the node does not exist" do
      expect { graph.validate_node(:z, "Z") }.to raise_error(InvalidNode) 
    end
    it "does not raise an exception if the node exists" do 
      expect { graph.validate_node(:a, "A") }.not_to raise_error(InvalidNode) 
    end
  end
end

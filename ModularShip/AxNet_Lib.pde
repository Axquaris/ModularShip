

public class Buffer {
  protected float output;
  
  public Buffer() {
    output = 0;
  }
  
  public void setOutput(float f) {
    output = f;
  }
  
  public float getOutput() {
    return output;
  }
  
  public float getOutput(int n) {
    return output;
  }
}

public class NeuralLayer {
  
  private Neuron[] neurons;
  
  public NeuralLayer(int numNeurons) {
    neurons = new Neuron[numNeurons];
    
    for (int i = 0; i < numNeurons; i++)
      neurons[i] = null;
  }
  
  public NeuralLayer(Neuron[] neurons) {
    this.neurons = neurons;
  }
  
  public void process() {
    for (Neuron n: neurons)
      n.process();
  }
  
  //Mutator Methods
  public int addNeuron(Neuron n) {
    for (int i = 0; i < neurons.length; i++) {
      if (neurons[i] == null) {
        neurons[i] = n;
        return i;
      }
    }
    return -1;
  }
  
  public int addNeurons(Neuron[] n) {
    for (int i = 0; i <= neurons.length - n.length; i++) {
      if (neurons[i] == null) {
        for (int j = 0; j < n.length; j++)
          neurons[i+j] = n[j];
        return i;
      }
    }
    return -1;
  }
  
  //Acessor Methods
  public Neuron getNeuron(int i) {
    return neurons[i];
  }
  
  public Neuron[] getNeurons(int i) {
    return neurons;
  }
}


public class NeuralNetwork {
  
  public Buffer[] input;
  private NeuralLayer[] layers;
  public NeuralLayer output;
  
  public NeuralNetwork(int numInputs, int numLayers) {
    input = new Buffer[numInputs];
    layers = new NeuralLayer[numLayers];
    
    for (int i = 0; i < numInputs; i++)
      input[i] = null;
    for (int i = 0; i < numLayers; i++)
      layers[i] = null;
  }
  
  public NeuralNetwork(int numInputs, int[] numLayers) {
    input = new Buffer[numInputs];
    layers = new NeuralLayer[numLayers.length];
    
    for (int i = 0; i < numInputs; i++)
      input[i] = null;
    for (int i = 0; i < numLayers.length; i++)
      layers[i] = new NeuralLayer(numLayers[i]);
  }
  
  public NeuralNetwork(Buffer[] input, NeuralLayer[] layers) {
    this.input = input;
    this.layers = layers;
  }
  
  public void process() {
    for (NeuralLayer nl: layers)
      nl.process();
    output = layers[layers.length-1];
  }
  
  //Mutator Methods
  public int addLayer(NeuralLayer nl) {
    for (int i = 0; i < layers.length; i++) {
      if (layers[i] == null) {
        layers[i] = nl;
        return i;
      }
    }
    return -1;
  }
  
  public int addLayers(NeuralLayer[] nl) {
    for (int i = 0; i <= layers.length - nl.length; i++) {
      if (layers[i] == null) {
        for (int j = 0; j < nl.length; j++)
          layers[i+j] = nl[j];
        return i;
      }
    }
    return -1;
  }
}


public class Neuron extends Buffer {
  private final float E = 2.71828183f;
  
  private Buffer[] inputs;
  private float[] weights;
  private float bias;
  
  private float lastOutput;
  private int timesFired;
  
  public Neuron(int numInputs) {
    inputs = new Buffer[numInputs];
    weights = new float[numInputs];
    
    for (int i = 0; i < numInputs; i++)
      inputs[i] = null;
    for (int i = 0; i < numInputs; i++)
      weights[i] = 1;
    bias = 0;
    
    timesFired = 0;
  }
  
  public Neuron(Buffer[] inputs, float[] weights, float bias) {
    this.inputs = inputs;
    this.weights = weights;
    this.bias = bias;
    
    timesFired = 0;
  }
  
  public void process() {
    //Activation Function
    float activation = 0;
    for (int i = 0; i < inputs.length; i++) {
      activation += inputs[i].getOutput(timesFired) * weights[i];
    }
    activation += bias;
    
    //Transfer Function
    lastOutput = output;
    output = 2 / (1 + pow(E, -2*activation)) - 1;
    timesFired++;
  }
  
  //Mutator Methods
  public int addInput(Buffer n) { //adds self to inputs of given neuron
    for(int i = 0; i < inputs.length; i++) {
      if(inputs[i] == null) {
        inputs[i] = n;
        return i;
      }
    }
    return -1;
  }
  
  public int addInput(Buffer n, float weight) {
    int i = addInput(n);
    if (i != -1)
      weights[i] = weight;
    return i;
  }
  
  public void setWeight(float w ,int i) {
    weights[i] = w;
  }
  
  public void setWeight(float w ,Buffer f) {
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i] == f)
        setWeight(w, i);
    }
  }
  
  public void setBias(float b) {
    bias = b;
  }
  
  //Acessor Methods
  public float getWeight(int i) {
    return weights[i];
  }
  
  public float getWeight(Buffer f) {
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i] == f)
        return getWeight(i);
    }
    System.err.println("ERROR AT NEURON "+this+".getWeight(Buffer f)");
    return 0;
  }
  
  public float getBias() {
    return bias;
  }
  
  @Override
  public float getOutput(int otherTimesFired) {
    if (timesFired > otherTimesFired)
      return lastOutput;
    return output;
  }
}
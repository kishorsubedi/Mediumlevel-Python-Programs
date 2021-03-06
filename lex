# Class Queue to represent a queue 
class queue: 
  
    # __init__ function 
    def __init__(self, capacity): 
        self.front = self.size = 0
        self.rear = capacity -1
        self.Q = [None]*capacity 
        self.capacity = capacity 
      
    # Queue is full when size becomes 
    # equal to the capacity  
    def isFull(self): 
        return self.size == self.capacity 
      
    # Queue is empty when size is 0 
    def isEmpty(self): 
        return self.size == 0
  
    # Function to add an item to the queue.  
    # It changes rear and size 
    def EnQueue(self, item): 
        if self.isFull(): 
            print("Full") 
            return
        self.rear = (self.rear + 1) % (self.capacity) 
        self.Q[self.rear] = item 
        self.size = self.size + 1
        #print("%s enqueued to queue"  %str(item)) 
  
    # Function to remove an item from queue.  
    # It changes front and size 
    def DeQueue(self): 
        if self.isEmpty(): 
            print("Empty") 
            return
          
        #print("%s dequeued from queue" %str(self.Q[self.front])) 
        x = self.Q[self.front]
        self.front = (self.front + 1) % (self.capacity) 
        self.size = self.size -1
        return x
          
    # Function to get front of queue 
    def que_front(self): 
        if self.isEmpty(): 
            print("Queue is empty") 
  
        print("Front item is", self.Q[self.front]) 
          
    # Function to get rear of queue 
    def que_rear(self): 
        if self.isEmpty(): 
            print("Queue is empty") 
        print("Rear item is",  self.Q[self.rear]) 
  
def file_path_to_inst_array(nfa_instruction_filepath):
    nfa_file = open(nfa_instruction_filepath, "r")
    p = ""
    for each in nfa_file:
        p = p + each 
    return p.split("\n")

def putinqueue(q, qset, inst_index):
    if(inst_index not in qset):
        qset.add(inst_index)
        q.EnQueue(inst_index)
    return q 

def method(instruction_array, input_text, char_index):
    match = False
    max_index = char_index
    max_match_pc = 0
    clist = queue(len(instruction_array))
    clistset = set()

    nlist = queue(len(instruction_array))
    nlistset = set()

    putinqueue(clist, clistset, 0)
    while(char_index <= len(input_text)):
        while(len(clistset) != 0):

            pc = clist.DeQueue()
            clistset.remove(pc)
            instruction = instruction_array[pc].split(" ")
            inst_opcode = instruction[1]
            
            if(inst_opcode == "char"):#range 
                if(int(instruction[2]) == ord(input_text[char_index]) ):
                    putinqueue(nlist, nlistset, pc+1)

            elif(inst_opcode == "jump"):
                putinqueue(clist, clistset, instruction[2])

            elif(inst_opcode == "match"):
                if(char_index > max_index):
                    max_index = char_index
                    max_match_pc = pc
                    match = True
                if(char_index == len(input_text)):
                    print("Match at PC", max_match_pc, "for tc until(exclusive)", max_index)
                    return max_index
            else:
                putinqueue(clist, clistset, int(instruction[2]))
                putinqueue(clist, clistset, int(instruction[3]))

        clist = nlist
        clistset = nlistset 
        nlist = queue(len(instruction_array))
        nlistset = set() 
        char_index +=1

    if(match == False):
        return 0 
    else:
        print("Match at PC", max_match_pc, "for tc until(exclusive)", max_index)
        return max_index

    
#def thompsonvm(input_text, nfa_instruction_filepath):
def thompsonvm(input_text, instruction_array):
    #instruction_array = file_path_to_inst_array(nfa_instruction_filepath)
    main_matches = []

    char_index = 0
    while(char_index < len(input_text)):
        returned = method(instruction_array, input_text, char_index)#2
        if(returned == 0):
            return 0
        char_index = returned#2

a = ['0 split 1 3 ', '1 char 97 97 ', '2 match', '3 char 97 97', '4 char 97 97', '5 match']
print(thompsonvm("aaa", a))#if match at end of the string, string index out of range

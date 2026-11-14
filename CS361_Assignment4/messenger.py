
import zmq


context = zmq.Context()


sender = context.socket(zmq.REQ)


sender.connect("tcp://127.0.0.1:5555")


message = "This is a message from CS361"
sender.send_string(message)

print("Sent:", message)


reply = sender.recv_string()
print("Reply:", reply)

sender.close()
context.term()

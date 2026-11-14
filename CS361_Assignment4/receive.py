
import zmq


context = zmq.Context()


receiver = context.socket(zmq.REP)


receiver.bind("tcp://127.0.0.1:5555")

print("Waiting for a message...")


message = receiver.recv_string()
print("Received:", message)


receiver.send_string("Message received!")

receiver.close()
context.term()

from modules import *
from routes import *

# Starting the python applicaiton
if __name__ == '__main__':
    # Step 1: Change this port number if needed
    PORT_NUMBER = 5005

    print("-"*70)
    print("""Welcome to Media Server Backend.\n
             Please open your browser to:
             http://127.0.0.1:{}""".format(PORT_NUMBER))
    print("-"*70)

    # Note, you're going to have to change the PORT number
    app.run(debug=True, host='0.0.0.0', port=PORT_NUMBER)

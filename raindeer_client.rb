require "socket"

def connect
    streamSock = TCPSocket.new( "10.112.148.185", 8080 )  
    str = streamSock.recv( 100 )  
    streamSock.write( "Ruby\n" )  
    streamSock
end

def read_state(sock)
    str = sock.recv( 100 )  
    state = str.split(' ')
end

def possible_moves(state)
    directions = state.each{|dir| [:E,:W,:N,:S].include?(dir[0])}
    possible_moves = directions.select{ |dir| dir[1] != "?" and Integer(dir[1]) > 0 }
    return possible_moves.collect{ |dir|  dir[0] }
end

def have_present(state)
    present = state.select{ |dir| dir[0] == "P" and dir[1] != "?" }
    return present.length > 0    
end

def make_move(sock, move)
    sock.write(move+"\n")
end

def opposite_move(move)
    if move == "N"
        "S"
    elsif move == "S"
        "N"
    elsif move == "E"
        "W"
    elsif move == "W"
        "E"
    end
end

def main
    sock = connect
    state = read_state(sock)
    last_move = "fuck knows"
    while not have_present(state)
        moves = possible_moves(state)
        if moves.length == 2 and moves.include?(last_move)
            move = last_move
        elsif moves.select{ |move| move != opposite_move(last_move)}.length >= 1
            moves = moves.select{ |move| move != opposite_move(last_move)}
            move = moves[rand(moves.length)]
        else
            move = moves[rand(moves.length)]
        end
        make_move(sock, move)
        state = read_state(sock)
        last_move = move
    end
    puts "Got present! Oh yeah!"
    sock.close  
    main
end

main

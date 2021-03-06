module TransmissionServer
  attr_accessor :connectors

  def receive_data data
    query = JSON.parse(data)
    case query['command']
      when 'add'
        respond = 'Add: '  + query['uri']
        target = query['client']
        ## Add magnet link to download client
        session = @connectors.find{|client| client.host == target['host'] and client.peer_port == target['port']}
        if session
          session.transmission.add_torrent_by_file(query['uri'])
          session.transmission.add_tracker(query['hash'], 'http://retracker.local/announce') if query['hash']
        end
      when 'move'
        respond = 'move'
        ## Move torrent from download to upload client
      else
        respond = 'Illegal operation'
    end
    puts respond
    send_data respond
    close_connection_after_writing
  end

end

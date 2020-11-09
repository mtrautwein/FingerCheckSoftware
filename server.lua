io.stdout:setvbuf('no')

local smtp = require("socket.smtp")

local excel_file = require "excelreader"


local lick = require 'lick'

local socket = require('socket')
udp = socket.udp()
local client_IP, client_PORT = 0, 0
udp:setsockname('*',12345)
udp:settimeout(0) 

local connected_to_client = false

local update_speed = 2
local update_max = 6
local update_value = 0

data_to_send = '...'

local excel_table = nil

function LOAD_excel(file_name)
	local m
	m = excel_file.read('./'..file_name..'.csv')
	create_data_to_send_bool = true 

	excel_table = {}

	local l 
	local i = 0
	for l = 2,17 do -- l = 2,16
		excel_table[i] = {}

		excel_table[i][1] = m[l][3]
		excel_table[i][2] = m[l][7]
		excel_table[i][3] = m[l][8]
		
		i = i + 1
	end

	local l,c
	local x,y=10,10
	for l = 1,#excel_table do 
		for c = 1,#excel_table[l] do 
			data_to_send = data_to_send..'/'..tostring(excel_table[l][c])
		end	
	end	
end	

function love.load()
	data_to_send = '...'--'RIEN'
	LOAD_excel('excel_file')
end

function udpate_load(dt)
	update_value = update_value + update_speed*dt
	if update_value >= update_max then 
		update_value = 0
		love.load()
	end	
end	


function love.update(dt)
	udpate_load(dt)

	-- DATA reception from the client 
	data, ip, port = udp:receivefrom()

	if data then 
		if ip ~= nil and ip ~= timeout and port ~= nil then
			 client_IP = ip
			 client_PORT = port
		end	
		udp:sendto(data_to_send, client_IP, client_PORT) 
		connected_to_client = true
	end
end	

function love.draw()
	love.graphics.print('Refresh Excel : '..math.floor(update_value)..'/5',600,580)
	love.graphics.print('ETAT DE CONNEXION : '..tostring(connected_to_client),10,580)
	love.graphics.printf(data_to_send, 10, 10, 700)

	local l,c
	local x,y=50,70
	for l = 1,#excel_table do 
		for c = 1,#excel_table[l] do 
			love.graphics.print(excel_table[l][c],x,y)
			x = x+60 
		end
		y = y + 30
		x = 50
	end		
end

function love.keypressed(key)
end	
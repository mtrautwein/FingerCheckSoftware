--
-- SHA-256 Hashing Algorithm /// by MAXIMILIEN TRAUTWEIN, 2020
--

security = {}

function security.hashing(pInput_password)
	function decimal_to_binary(pDecimal)
		function reverse_binary(pBinary_value)
			local reverse_binary_value = {}
			local incremant = 0
			local b
			for b = #pBinary_value, 1, -1 do 
				incremant = incremant + 1
				reverse_binary_value[incremant] = pBinary_value[b]
			end	
			return reverse_binary_value
		end	

		local step = pDecimal
		local step_minus_1
		local binary_value = {}
		local nb_de_fois_step_0 = 0
		local Break = 0
		while step >= 0 and Break == 0 do 
			step_minus_1 = step 
			step = math.floor(step_minus_1/2)
			local remainder = step_minus_1 - (2*step) 
			binary_value[#binary_value+1] = remainder
			if step == 0 then 
				nb_de_fois_step_0 = nb_de_fois_step_0 + 1
			end	

			if nb_de_fois_step_0 >= 2 then 
				Break = 1
			end	
		end

		return reverse_binary(binary_value)
	end	

	function decimal_to_hex(pDecimal_string)
		if pDecimal_string == '0' then 
			return '0'
		elseif pDecimal_string == '1' then
			return '1'
		elseif pDecimal_string == '2' then 
			return '2'
		elseif pDecimal_string == '3' then 	
			return '3'
		elseif pDecimal_string == '4' then
			return '4'
		elseif pDecimal_string == '5' then 	
			return '5'
		elseif pDecimal_string == '6' then
			return '6'
		elseif pDecimal_string == '7' then 	
			return '7'
		elseif pDecimal_string == '8' then 
			return '8'	
		elseif pDecimal_string == '9' then 	
			return '9'
		elseif pDecimal_string == '10' then 	
			return 'A'
		elseif pDecimal_string == '11' then 	
			return 'B'
		elseif pDecimal_string == '12' then 	
			return 'C'
		elseif pDecimal_string == '13' then 	
			return 'D'
		elseif pDecimal_string == '14' then 	
			return 'E'
		elseif pDecimal_string == '15' then 	 
			return 'F'	 	
		end	
	end	

	function binary_to_decimal(pBinary)
		local i
		local decimal_value = 0
		local exponent = -1
		for i = #pBinary, 1, -1 do 
			exponent = exponent + 1
			decimal_value = decimal_value + pBinary[i]*math.pow(2,exponent)
		end	

		return decimal_value
	end	

	function binary_to_hex(pBinary)
		--
		return string.format('0x%x',binary_to_decimal(pBinary))
	end	

	function hex_to_binary(pHex)
		--
		return decimal_to_binary(tonumber(pHex))
	end	

	function stringHex_to_hex(pStringHex)
		--
		return string.format('0x%x',pStringHex)
	end	

	local input = pInput_password

	local input_decimal = {}
	local input_binary = {}

	-- Convert input password to decimal then to binary --
	local d
	for d = 1, #input do 
		input_decimal[d] = string.byte(input[d])
		if d == 1 then 
			input_binary = decimal_to_binary(input_decimal[d])
		else 
			local binary_table = decimal_to_binary(input_decimal[d])
			local e
			for e = 1,#binary_table do
				table.insert(input_binary, binary_table[e])
			end
		end	
	end	

	-- CREATION OF THE 512 BITS BLOCK

	-- Convert input_binary_lenght_decimal_value to binary
	local input_binary_lenght_decimal_value = #input_binary
	local input_binary_lenght_binary_value = decimal_to_binary(input_binary_lenght_decimal_value)

	-- Add 1 to input_binary to mark the end of the phrase
	input_binary[#input_binary+1] = 1

	-- Fill the block with 0 in between the input_binary phrase at..
	-- ..the beginning of the block and input_binary_lenght_binary_value at the end.
	local number_of_0 = 512 - (#input_binary_lenght_binary_value+#input_binary)

	local block_512 = {}

	-- 1/ beginning of block_512 = input_binary
	local b
	for b = 1,#input_binary do 
		table.insert(block_512,input_binary[b])
	end	

	-- 2/ fill block_512 with 0
	local f
	for f = 1, number_of_0 do
		table.insert(block_512,0)
	end	

	-- 3/ add at the end : input_binary_lenght_binary_value
	local a
	for a = 1, #input_binary_lenght_binary_value do 
		table.insert(block_512,input_binary_lenght_binary_value[a])
	end	

	-- Divide block_512 into 16*32bits chunks
	local chunk_64 = {}
	local b512
	local i_64 = 0
	for b512 = 1, #block_512,32 do 
		i_64 = i_64 + 1
		chunk_64[i_64] = {} -- ex : chunk_64[1] = {1,1,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,1,0,2} /// = 2 dimensions array
			local i_32
			for i_32 = 1,32 do 
				table.insert(chunk_64[i_64],block_512[(b512-1)+i_32])
			end	
	end	

	function xor(a,b)
		local result_binary = {}
		local i_32
		for i_32 = 1, 32 do 
			if a[i_32] == 1 and b[i_32] == 1 then 
				result_binary[i_32] =  0 
			elseif a[i_32] == 1 and b[i_32] == 0 then 
				result_binary[i_32] =  1 
			elseif a[i_32] == 0 and b[i_32] == 1 then 
				result_binary[i_32] =  1
			elseif a[i_32] == 0 and b[i_32] == 0 then 
				result_binary[i_32] =  0 
			end		
		end		
		return result_binary 	
	end	

	function _and(a,b)
		local result_binary = {}
		local i_32
		for i_32 = 1, 32 do 
			if a[i_32] == 1 and b[i_32] == 1 then 
				result_binary[i_32] =  1 
			elseif a[i_32] == 1 and b[i_32] == 0 then 
				result_binary[i_32] =  0
			elseif a[i_32] == 0 and b[i_32] == 1 then 
				result_binary[i_32] =  0
			elseif a[i_32] == 0 and b[i_32] == 0 then 
				result_binary[i_32] =  0 
			end		
		end			
		return result_binary 
	end	


	function rightrotate(pArray,offset)
		if offset == 0 then offset = 1 end
		local o
		local length = #pArray
		local beginning_array = {}
		for o = 1, offset do 		
			local p
			for p = length,1,-1 do 
				pArray[p+1] = pArray[p]
				if p+1 > length then 
					table.insert(beginning_array,pArray[p])
				end
			end	
		end

		local r 
		local i = 0
		for r = #beginning_array, 1, -1 do 
			i = i + 1
			pArray[i] = beginning_array[r]
		end	

		table.remove(pArray,#pArray)

		return pArray
	end	

	-- Increase the number of chunk from 16 to 64
	-- create each new chunk with xor addition and lefrotate
	local s_to_s
	for s_to_s = 17, 64 do 
		chunk_64[s_to_s] = {}
		local a3 = rightrotate(chunk_64[s_to_s-3],3)
		local a8 = rightrotate(chunk_64[s_to_s-8],8)
		local a16 = rightrotate(chunk_64[s_to_s-16],16)

		chunk_64[s_to_s] = xor(a3,a8)
		chunk_64[s_to_s] = xor(chunk_64[s_to_s],a16)

		rightrotate(chunk_64[s_to_s],15)
	end

	--Initialize hash values:
	--(first 32 bits of the fractional parts of the square roots of the first 8 primes 2..19):
	h0 = 0x6a09e667
	h1 = 0xbb67ae85
	h2 = 0x3c6ef372
	h3 = 0xa54ff53a
	h4 = 0x510e527f
	h5 = 0x9b05688c
	h6 = 0x1f83d9ab
	h7 = 0x5be0cd19

	--Initialize array of round constants:
	--(first 32 bits of the fractional parts of the cube roots of the first 64 primes 2..311):
	k = {
	   0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	   0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	   0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	   0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	   0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	   0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	   0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	   0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
	   }

	a = h0
	b = h1
	c = h2
	d = h3
	e = h4
	f = h5
	g = h6
	h = h7

	-- main loop, avalanche effect
	local ii
	for ii = 1, 59 do
		local a_binary = hex_to_binary(a)
		local b_binary = hex_to_binary(b)
		local c_binary = hex_to_binary(c)
		local e_binary = hex_to_binary(e)
		local f_binary = hex_to_binary(f)
		local g_binary = hex_to_binary(g)

		local s1 = xor(rightrotate(e_binary,6),rightrotate(e_binary,11))
		s1 = xor(s1,rightrotate(e_binary,25))
		local ch = xor(_and(e_binary,f_binary),_and(e_binary,g_binary))
			
		local T1 = string.format('0x%x',binary_to_hex(s1) + binary_to_hex(ch) + k[ii] + binary_to_hex(chunk_64[ii]) + h7)

		local s2 = xor(rightrotate(a_binary,2),rightrotate(a_binary,13))
		s2 = xor(s2,rightrotate(a_binary,22))
		local ch2 = xor(_and(a_binary,b_binary),_and(a_binary,c_binary))
		ch2 = xor(ch2,_and(b_binary,c_binary))

	    local T2 = string.format('0x%x',binary_to_hex(s2) + binary_to_hex(ch2) + binary_to_hex(chunk_64[ii]))

	    h = g
	    g = f
	    f = e
	    e = d + T1
	    d = c
	    c = b
	    b = a
	    a = T1 + T2

	   -- Add the compressed chunk to the current hash value:

	    h0 = h0 + a
	    h1 = h1 + b
	    h2 = h2 + c
	    h3 = h3 + d
	    h4 = h4 + e
	    h5 = h5 + f
	    h6 = h6 + g
	    h7 = h7 + h
	end	

	FINAL_HASH = string.format('%08x',h0)..string.format('%08x',h1)..string.format('%08x',h2)..string.format('%08x',h3)..string.format('%08x',h4)..string.format('%08x',h5)..string.format('%08x',h6)..string.format('%08x',h7)

	PS_HASH = 'cd3f9e1cdc2780008fd383af6ad0e00064c8f9e15fc80000469fd31f11160000febce8547112b800b2816aac955c80007d16180e1e8fd00057a738e117aee400'

	--print("FINAL_HASH -> "..FINAL_HASH)
	--print("PS_HASH -> "..PS_HASH)

	if FINAL_HASH == PS_HASH then 
		return true
	else 
		return false	
	end	
end	 

return security
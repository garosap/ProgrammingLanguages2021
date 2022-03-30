fun round filename = 
    let
        fun parse file =
            let
            (* A function to read an integer from specified input. *)
                fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

                (* Open input file. *)
                val inStream = TextIO.openIn file

                val (n, m) = (readInt inStream, readInt inStream)
                val _ = TextIO.inputLine inStream


                fun loop ins =
                    case TextIO.scanStream (Int.scan StringCvt.DEC) ins of
                        SOME i => (i :: loop ins)
                        | NONE => []



                val inputList = loop inStream

                val _ = TextIO.closeIn inStream        

            in
                (n, m, inputList)
            end

        val (cities, cars, initialState) = parse filename;   

    
        fun maxVal r1 r2 =
            if r1 < r2 then r2
            else r1
 

        fun calcDistance source destination = 
            if source <= destination then destination - source 
            else cities - source + destination


        (* Given a state and a city, it returns a tuple with the sum of all moves needed for every car to be at that city *)
        (* and the max distance for 1 car *)
        fun calcSumMax [] sum max city = (sum, max, city)
            | calcSumMax (h::t) sum max city =
                let  
                    val distance = calcDistance h city;
                in
                    calcSumMax t (distance + sum) (maxVal distance max) city
                end

        fun checkValid (sum, max, city) =
            let 
                val temp = (max - (sum - max))
            in 
                if temp > 1 then false
                else true
            end 

        fun findOptimal (sum, max, city) (~1, ~1, ~1) = (sum, max, city)
            | findOptimal (sum1, max1, city1) (sum2, max2, city2) =
                if sum1 < sum2 then (sum1, max1, city1) 
                else (sum2, max2, city2) 


        fun solve i optimal = 
            if i = cities then optimal
            else
                let
                    val results = calcSumMax initialState 0 0 i;
                    val isValid = checkValid results
                in
                    if isValid then solve (i+1) (findOptimal results optimal)
                    else solve (i+1) optimal
                end

        
        val (finalSum, finalMax, finalCity)  = solve 0 (~1, ~1, ~1);

    in 
        print((Int.toString finalSum) ^ " " ^ (Int.toString finalCity) ^ "\n")
    end


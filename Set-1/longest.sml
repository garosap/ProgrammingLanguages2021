fun longest filename =
    let
        val maxDiff : int ref = ref ~1     

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
                val inputArray = Array.fromList inputList
                val _ = TextIO.closeIn inStream        

            in
                (n, m, inputArray)
            end

            val (d, hospitals, arr) = parse filename;    

            fun iterate (n, f) =
                let fun go i = 
                if i < n then (
                    f i;
                    go (i + 1)
                )
                else ()
                in
                    go 0
                end   

            fun inverseIterateToZero (n, f) =
                let fun go i = 
                if i >= 0 then (
                    f i;
                    go (i - 1)
                )
                else ()
                in
                    go n
                end   


            fun modifyInputArray arr = (
                iterate(d, fn i =>(
                    Array.update(arr, i, Array.sub(arr, i)*(~1) - hospitals )
                ))
            );
                
            val temp = modifyInputArray arr;
            
            val prefixArr = Array.array(d+1, 0);

            fun createPrefixArray (arr, prefixArr) = 
                iterate(d, fn i => (
                    Array.update(prefixArr, i+1, Array.sub(prefixArr, i) + Array.sub(arr, i)  )
                ))

            val temp = createPrefixArray (arr, prefixArr);

            fun calcMaxDiff (i, j, LMin, RMax, n) =
                    if i < n andalso j < n then
                        if Array.sub(LMin, i) <= Array.sub(RMax, j) then (
                            maxDiff := Int.max (!maxDiff, j - i);
                            calcMaxDiff (i, j+1, LMin, RMax, n)
                        )
                        else
                            if j > i then calcMaxDiff (i+1, j, LMin, RMax, n)
                            else calcMaxDiff (i, j+1, LMin, RMax, n)
                    else ()        

            fun maxIndexDiff (arr, n) =
                let
                    val LMin = Array.array(n, 0);
                    val RMax = Array.array(n, Array.sub(arr, n-1));
                in

                    iterate(n-1, fn i => (
                        Array.update(LMin, i+1, Int.min (Array.sub(arr, i+1),  Array.sub(LMin, i))  )
                    ));

                    inverseIterateToZero(n-2, fn i => (
                        Array.update(RMax, i, Int.max (Array.sub(arr, i), Array.sub(RMax, i+1))  )
                    ));


                    calcMaxDiff (0, 0, LMin, RMax, n)

                end
            
            
                

    in
        maxIndexDiff (prefixArr, d+1);
        print ( Int.toString(!maxDiff) ^ "\n")
    end

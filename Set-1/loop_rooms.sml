fun loop_rooms filename =
    let
        val counter : int ref = ref 0

        fun check (i, j, n, m, a, b) = (
            if (Array2.sub(b, i, j) = 1) orelse (Array2.sub(b, i, j) = ~1) then Array2.sub(b, i, j)
            else 
                if Array2.sub(b, i, j) = 2 then ~1
                else  case Array2.sub(a, i, j)
                      of #"U" => if i = 0 then 1
                        else (
                            Array2.update(b, i, j, 2);
                            Array2.update(b, i - 1, j, check(i - 1, j, n, m, a, b));
                            Array2.sub(b, i-1, j)
                        )
                      | #"D" => if i = n-1 then 1
                        else (
                            Array2.update(b, i, j, 2);
                            Array2.update(b, i + 1, j, check(i + 1, j, n, m, a, b));
                            Array2.sub(b, i+1, j)
                        ) 
                      | #"L" => if j = 0 then 1
                        else (
                            Array2.update(b, i, j, 2);
                            Array2.update(b, i, j-1, check(i, j-1, n, m, a, b));
                            Array2.sub(b, i, j-1)
                        ) 
                      | #"R" => if j = m-1 then 1
                        else (
                            Array2.update(b, i, j, 2);
                            Array2.update(b, i, j+1, check(i, j+1, n, m, a, b));
                            Array2.sub(b, i, j+1)
                        )    
                      | _ => 200

        )
                    
            

        fun parse file =
            let
            (* A function to read an integer from specified input. *)
                fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

                (* Open input file. *)
                val inStream = TextIO.openIn file

                val (n, m) = (readInt inStream, readInt inStream)
                val _ = TextIO.inputLine inStream

                (* reads a line and turns it into a char list (omit newLine), return char list list *)
                fun readLines acc =
                    case TextIO.inputLine inStream of
                        NONE => rev acc
                        | SOME line => readLines (explode (String.substring (line, 0, m)) :: acc)

                val inputList = readLines []:char list list
                val inputArray = Array2.fromList inputList
                val _ = TextIO.closeIn inStream        

            in
                (n, m, inputArray)
            end


        val (n, m, a) = parse filename;    
        val b = Array2.array (n, m, 0);

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

        fun loop (n, m, a, b) =
            iterate(n, fn i => 
                iterate(m, fn j =>(
                  Array2.update(b, i, j, check(i, j, n, m, a, b));
                  if(Array2.sub(b, i, j) = ~1) then counter := !counter + 1
                  else ()
                )))
        
        
    in
        loop (n, m, a, b);
        print (Int.toString(!counter) ^ "\n")

    end

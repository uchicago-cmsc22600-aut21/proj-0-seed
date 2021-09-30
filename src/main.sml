(* main.sml
 *
 * CMSC 22600 Autumn 2021 Sample Code
 *
 * COPYRIGHT (c) 2021 John Reppy (http://cs.uchicago.edu/~jhr)
 * All rights reserved.
 *)


structure Main : sig

    val main : string * string list -> OS.Process.status

  end = struct

    (* report an error *)
    fun error msg = (
          TextIO.output(TextIO.stdErr, msg);
          OS.Process.failure)

    (* process an input file by reading it in, converting to a lambda expression,
     * evaluating to WHNF, and printing the result.
     *)
    fun doFile src = (case SExpParser.parseFile src
           of [sexp] => (case Lambda.fromSExp sexp
                 of SOME lexp => (
                      SExpPrinter.print(
                        TextIO.stdOut,
                        Lambda.toSExp(Eval.reduceToWHNF lexp));
                      TextIO.output(TextIO.stdOut, "\n");
                      OS.Process.success)
                  | NONE => error "invalid input\n"
                (* end case *))
            | _ => error "invalid input\n"
          (* end case *))

    fun main (_, [src]) = if OS.FileSys.access(src, [])
          then doFile src
          else error(concat["input file '", src, "' does not exist\n"])
      | main _ = error "expecting a single source-file argument\n"

  end

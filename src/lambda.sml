(* lambda.sml
 *
 * CMSC 22600 Autumn 2021 Sample Code
 *
 * COPYRIGHT (c) 2021 John Reppy (http://cs.uchicago.edu/~jhr)
 * All rights reserved.
 *)

structure Lambda : sig

    type var = Atom.atom

    (* lambda-calculus expressions *)
    datatype exp
      = Var of var              (* variable use occurrence *)
      | App of exp * exp        (* application *)
      | Abs of var * exp        (* lambda abstraction *)

    (* conversions to/from S-Expressions; we use the following
     * S-Expression syntax for lambda terms:
     *
     *  exp ::= var                     -- for Var
     *       |  '(' `@` exp exp ')'     -- for App
     *       |  '(' '/' var exp ')'     -- for Abs
     *
     * where variables are S-Expression symbols that start with a
     * letter.
     *)
    val fromSExp : SExp.value -> exp option
    val toSExp : exp -> SExp.value

    (* create a fresh variable from a given variable.  Fresh variable names
     * start with a leading "_", so they do not follow the source-variable
     * namiong convention.
     *)
    val freshVar : var -> var

  end = struct

    type var = Atom.atom

    (* lambda-calculus expressions *)
    datatype exp
      = Var of var              (* variable use occurrence *)
      | App of exp * exp        (* application *)
      | Abs of var * exp        (* lambda abstraction *)

  (* the operator symbols *)
    val apply = Atom.atom "@"
    val lambda = Atom.atom "/"

    (* test if an atom is a valid variable; i.e., it starts with a letter
     * and is not the work "lambda".  Note that since the source
     * of these is the S-Expression parser, we assume that the
     * atom is not the empty string.
     *)
    fun validVar atm =
          Char.isAlpha(String.sub(Atom.toString atm, 0))
          andalso not(Atom.same(atm, lambda))

    fun fromSExp (SExp.SYMBOL x) = if validVar x
          then SOME(Var x)
          else NONE
      | fromSExp (SExp.LIST[SExp.SYMBOL oper, se1, se2]) =
          if Atom.same(oper, apply)
            then (case (fromSExp se1, fromSExp se2)
               of (SOME e1, SOME e2) => SOME(App(e1, e2))
                | _ => NONE
              (* end case *))
          else if Atom.same(oper, lambda)
            then (case (se1, fromSExp se2)
               of (SExp.SYMBOL x, SOME e) => if validVar x
                    then SOME(Abs(x, e))
                    else NONE
                | _ => NONE
              (* end case *))
            else NONE
      | fromSExp _ = NONE

    fun toSExp (Var x) = SExp.SYMBOL x
      | toSExp (App(e1, e2)) = SExp.LIST[
            SExp.SYMBOL apply, toSExp e1, toSExp e2
          ]
      | toSExp (Abs(x, e)) = SExp.LIST[
            SExp.SYMBOL lambda, SExp.SYMBOL x, toSExp e
          ]

    local
      val cnt = ref 0
    in
    fun freshVar x = let
          val n = !cnt
          in
            cnt := n+1;
            Atom.atom(concat["_", Atom.toString x, Int.toString n])
          end
    end (* local *)

  end

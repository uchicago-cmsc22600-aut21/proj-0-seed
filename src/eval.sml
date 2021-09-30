(* eval.sml
 *
 * COPYRIGHT (c) 2021 John Reppy (http://cs.uchicago.edu/~jhr)
 * All rights reserved.
 *)

structure Eval : sig

    (* `beta (x, e1, e2)` reduces the application `(\x . e1) e2` *)
    val beta : Lambda.var * Lambda.exp * Lambda.exp -> Lambda.exp

    (* `oneStep e` returns `NONE` if `e` is in WHNF; otherwise if E[(\ x . e) e'] is
     * the head redux and e'' is the result of `beta(x, e, e')`, then it returns
     * `SOME(E[e''])`.
     *)
    val oneStep : Lambda.exp -> Lambda.exp option

    (* repeatedly apply the oneStep evaluation until the term is in WHNF *)
    val reduceToWHNF : Lambda.exp -> Lambda.exp

  end = struct

    structure L = Lambda

    fun beta _ = raise Fail "YOUR CODE HERE"

    fun oneStep _ = raise Fail "YOUR CODE HERE"

    fun reduceToWHNF _ = raise Fail "YOUR CODE HERE"

  end

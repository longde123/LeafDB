open Typs
open Ast

type evaluated = Table.t option * bool

let attempt_op db tbl op =
  match Database.lookup db tbl with
  | None -> (None, false)
  | Some x -> (Some (op x), true)

let attempt_join p1 p2 o =
  match p1 p2 with
  | Some x, Some y -> (Some(Table.join x y o), true)
  | _ -> (None, false)

let eval_select (db: Database.t) (e: expr) : Table.t option =
  match e with
  | Select (lst, tbl, w) ->
      (match Database.lookup db tbl with
        | None -> None
        | Some x -> Some(Table.select lst x w))
  | _ -> None

let eval (d : Database.t) (e : expr): evaluated =
  match e with
  | Select (lst, tbl, w) ->
      attempt_op(d)(tbl)(fun x -> Table.select lst x w)
  | SelectAll (tbl, w) ->
      attempt_op(d)(tbl)(fun x -> Table.selectAll x w)
  | Insert (tbl, clst, vlst) ->
      attempt_op(d)(tbl)(fun x -> Table.insert x clst vlst)
  | InsertAll (tbl, vlst) ->
      attempt_op(d)(tbl)(fun x -> Table.insertAll x vlst)
  | Delete (tbl, w) ->
      attempt_op(db)(tbl)(fun x -> Table.delete x w)
  | Update (tbl, cvlst, w) ->
      attempt_op(db)(tbl)(Table.update x cvlst w)
  | JoinTables (str1, str2, o) ->
      (match Database.lookup str1, Database.lookup str2 with
            | Some x, Some y -> (Some(Table.join x y o), true)
            | _ -> (None, false))
  | JoinTabQuer (str, e, o) ->
      (match Database.lookup str, eval_select(e) with
            | Some x, Some y -> (Some(Table.join x y o), true)
            | _ -> (None, false))
  | JoinQuerTab (e, str, o) ->
      (match eval_select(e), Database.lookup str with
            | Some x, Some y -> (Some(Table.join x y o), true)
            | _ -> (None, false))
  | JoinQueries (e1, e2, o) ->
      (match eval_select(e1), eval_select(e2) with
            | Some x, Some y -> (Some(Table.join x y o), true)
            | _ -> (None, false))
  | CreateTable(str, cdl) -> (None, Database.add_table d str Table.create(cdl))
  | CreateDb(str) -> (None, Dbms.add_database d str)
  | DropTable(str) -> (None, Database.drop d str)
  | DropDb(str) -> (None, Dbms.drop d str)



type expr =
  | Select of column list * string * where
  | SelectAll of string * where
  | Insert of string * column list * value list
  | JoinTables of string * string * on
  | JoinTabQuer of string * expr * on
  | JoinQuerTab of expr * string * on
  | JoinQueries of expr * expr * on
  | Update of string * (column, value) list
  | Delete of string * (column, value) list
  | CreateTable of string * column_dec list
  | CreateDb of string
  | DropTable of string
  | DropDb of string

let eval (d : database) (e : expr): Table.t option =
  match expr with
  | Select (lst, tbl, w) ->
  | Insert (tbl, clst, vlst) ->
      match Database.lookup tbl with
      | None -> None
      | Some x -> Some (Table.insert x clst vlst)




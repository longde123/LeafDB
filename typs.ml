(* represent our table columns as a string *)
type column  = string

(* a match between columns for relating tables *)
type on = column * column

(*(year, month, day)*)
type date = int * int * int

(* data types our database support *)
type value =
  | VInt of int
  | VString of string
  | VBool of bool
  | VFloat of float
  | VNull

let val_to_string value = match value with
  | VInt i -> string_of_int i
  | VString s -> s
  | VBool b -> string_of_bool b
  | VFloat f -> string_of_float f
  | VNull -> ""

(* supported operators in where used to conditionally select rows *)
type operator =
  | Gt | Lt | Eq | GtEq | LtEq | NotEq
  | LikeBegin | LikeEnd | LikeSubstring
  | NotLikeBegin | NotLikeEnd | NotLikeSubstring

(* SQL where expression: operate on the columns with the given value if there
 * is a condition, or Null if there is no condition
 *)
type where    =
  | Condition of (column * operator * value)
  | Null

(* declaration of a column with its associated value *)
type column_dec = column * value
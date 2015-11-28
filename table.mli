(* table.mli *)
open Core.Date
open Types

type t
(** Takes a column, the name of a table, returns the value associated with the
 * column.
 * [postcondition] : returns Some value or None if no table exists w/ that name
 *)
val lookup    : column -> string -> value option

(* Takes a list of columns, the name of a table, and a condition and returns a
 * query given that the columns listed are in the table and the condition is
 * valid on the values of the columns
 *)
val select    : column list -> string -> where -> t

(* Takes the name of a table, a list of columns, a list of values that
 * correspond respectively with the data types of the columns, and return a
 * table with the values appended to the columns
 *)
val insert    : t -> column list -> value list -> t

(* Takes a table name, and a list which has a length equal to the number of
 * columns and which values correspond to the data types of the columns in order
 * of the columns, and returns a table with the values appended to the columns
 *)
val insertAll : string -> value list -> t

(* Takes a table name, an updated list of (column * value) pairs, and a where
 * condition and returns an updated table for all records in which the condition
 * holds true
 *)
val update    : string -> (column * value) list -> where -> t

(* Takes a table name and an updated list of (column * value) pairs and returns
 * a table with all of the records updated
 *)
val updateAll : string -> (column * value) list -> t

(* Takes a table name, a list of (column * value) pairs, and returns *)
val delete    : string -> (column * value) list -> t

(* inner join
 * Takes two table names, and joins all rows from both tables where there is a
 * match between columns and joins them in a new table
 *)
val join      : string -> string -> on -> t

(* [precondition] : the two queries have the same number of columns
 * Takes two queries with the same number of columns and corresponding data
 * types. and appends one onto the other in a new query *)
val union     : t -> t -> t
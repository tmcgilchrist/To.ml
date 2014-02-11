open TomlType

(** Parsing functions a TOML file
  @return (string, TomlValue) Hashtbl.t
*)

let from_string string =
  TomlParser.toml TomlLexer.tomlex (Lexing.from_string string)

let from_channel chan =
  TomlParser.toml TomlLexer.tomlex (Lexing.from_channel chan)

let parse lexbuf =
  TomlParser.toml TomlLexer.tomlex lexbuf

(**
 * Functions to get the list of direct values / sub tables of a tomlTable
 *)

let get_tables toml =
  Hashtbl.fold (fun k v acc ->
                match v with
                | TTable v -> (k, v) :: acc
                | _ -> acc) toml []

let get_values toml =
  Hashtbl.fold (fun k v acc ->
                match v with
                | TTable _ -> acc
                | _ -> (k, v) :: acc) toml []

(** Generic getter *)

let get_value toml key = Hashtbl.find toml key

(**
 * Functions to retreive values of an expected type
 *)

let get_table toml key = match Hashtbl.find toml key with
  | TTable(tbl) -> tbl
  | _ -> failwith (key ^ " is a value")

let get_bool toml key = match get_value toml key with
  | TBool b -> b
  | _ -> failwith (key ^ " is not a boolean")

let get_int toml key = match get_value toml key with
  | TInt i -> i
  | _ -> failwith (key ^ " is not an integer")

let get_float toml key = match get_value toml key with
  | TFloat f -> f
  | _ -> failwith (key ^ " is not a float")

let get_string toml key = match get_value toml key with
  | TString s -> s
  | _ -> failwith (key ^ " is not a string")

let get_date toml key = match get_value toml key with
  | TDate d -> d
  | _ -> failwith (key ^ " is not a date")

(**
 * Functions to retreive OCaml primitive type list
 *)

let get_bool_list toml key = match get_value toml key with
  | TArray (NodeBool b) -> b
  | TArray (NodeEmpty) -> []
  | _ -> failwith (key ^ " is not a boolean array")

let get_int_list toml key = match get_value toml key with
  | TArray (NodeInt i) -> i
  | TArray (NodeEmpty) -> []
  | _ -> failwith (key ^ " is not an integer array")

let get_float_list toml key = match get_value toml key with
  | TArray (NodeFloat f) -> f
  | TArray (NodeEmpty) -> []
  | _ -> failwith (key ^ " is not a float array")

let get_string_list toml key = match get_value toml key with
  | TArray (NodeString s) -> s
  | TArray (NodeEmpty) -> []
  | _ -> failwith (key ^ " is not a string array")

let get_date_list toml key = match get_value toml key with
  | TArray (NodeDate d) -> d
  | TArray (NodeEmpty) -> []
  | _ -> failwith (key ^ " is not a date array")

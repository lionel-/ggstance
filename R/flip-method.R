
make_method <- function(method, args_collector, roundtrip = NULL,
                        what = "data") {

  flipped_method <- function(...) {
    on.exit(cleanup_roundtrip(dots, roundtrip))

    dots_names <- names(formals(sys.function()))
    dots <- set_names(map(dots_names, as.name), dots_names)
    dots <- do.call(args_collector, dots)

    if ("required_aes_error" %in% what) {
      tryCatch(res <- invoke(method, dots),
        error = flip_required_aes_error)
    } else {
      res <- invoke(method, dots)
    }

    if ("data" %in% roundtrip) {
      flip_aes(res)
    } else {
      res
    }
  }

  formals(flipped_method) <- formals(method)
  flipped_method
}

flip_required_aes_error <- function(e) {
  should_flip <- grepl(" requires the following missing aesthetics: ", e$message)
  if (should_flip) {
    msg <- flip_string(e$message)
  } else {
    msg <- e$message
  }

  stop(msg, call. = FALSE)
}

# FIXME: still a bit dirty as we temporarily change ggplot2 objects
cleanup_roundtrip <- function(dots, roundtrip) {
    if ("plot_scales" %in% roundtrip) {
      dots$plot$scales <- dots$plot$scales_orig
      dots$plot$scales_orig <- NULL
    }

    if ("mapping" %in% roundtrip) {
      dots$self$mapping <- flip_aes(dots$self$mapping)
      dots$self$stat$default_aes <- flip_aes(dots$self$stat$default_aes)
    }

    if (any(c("mapping", "plot_mapping") %in% roundtrip)) {
      dots$plot$mapping <- flip_aes(dots$plot$mapping)
    }

}

get_method <- function(method) {
  if (inherits(method, "ggproto_method")) {
    method <- environment(method)$f
  }
  method
}

flip_method_outer <- function(method, roundtrip = NULL, what = "data") {
  method <- get_method(method)
  args_collector <- partial(flip_method_dots, method, what = what)
  make_method(method, args_collector, roundtrip, what)
}

flip_method_dots <- function(method, ..., what = "data") {
  dots <- match_args(list(...), method)

  if ("data" %in% what) {
    dots$data <- flip_aes(dots[["data"]])
  }

  if ("scales" %in% what) {
    dots$panels <- flip_aes(dots[["panels"]])
    dots$scales <- flip_aes(dots[["scales"]])
  }

  if ("plot_scales" %in% what) {
    dots$plot$scales_orig <- dots$plot$scales
    dots$plot$scales <- scales_listh(dots$plot$scales)
  }

  if ("mapping" %in% what) {
    dots$self$mapping <- flip_aes(dots$self$mapping)
    dots$self$stat$default_aes <- flip_aes(dots$self$stat$default_aes)
    dots$plot$mapping <- flip_aes(dots$plot$mapping)
  }

  dots
}

# Match names of dots by position and by names
match_args <- function(dots, f) {
  args <- names(formals(f))
  args <- setdiff(args, c("self", names(dots)))
  index <- seq_along(dots)[names2(dots) == ""]

  if (length(index)) {
    names(dots)[index] <- args[seq_along(index)]
  }

  dots
}

lang_lookup <- map(flip_lookup, as.name)
lang_lookup <- splice(lang_lookup,
  GeomCrossbar = quote(ggstance::GeomCrossbarh),
  GeomLinerange = quote(ggstance::GeomLinerangeh)
)

flip_method_inner <- function(method, roundtrip = NULL) {
  method <- get_method(method)

  body <- body(method)
  body <- structure(body, class = "call") # Workaround for S3 dispatch on "{"
  body <- lazyeval::interp(body, .values = lang_lookup)
  body <- flip_lang(body, calls = c("data.frame", "transform"))
  body(method) <- body

  make_method(method, list, roundtrip)
}

call_name <- function(lang) {
  deparse(lang[[1]])
}

map_args <- function(.lang, .f, ...) {
  .lang[-1] <- map(as.list(.lang[-1]), .f, ...)
  .lang
}

flip_lang <- function(lang, calls) {
  if (is.call(lang)) {
    # Flip parameters of calls
    if (call_name(lang) %in% calls) {
      names(lang) <- flip_aes(names(lang))
    }
    lang <- map_args(lang, flip_lang, calls)
    return(lang)
  }

  if (is.character(lang)) {
    lang <- flip_string(lang)
    return(lang)
  }

  lang
}

flip_string <- function(string) {
  walk2(c("x", "y", "_x_"), c("_x_", "x", "y"), function(candidate, replacement) {
    pattern <- paste0("\\b(", candidate, ")(min|max|end)?\\b")
    replacement <- paste0(replacement, "\\2")
    string <<- gsub(pattern, replacement, string)
  })
  string
}

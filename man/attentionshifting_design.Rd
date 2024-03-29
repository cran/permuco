% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{attentionshifting_design}
\alias{attentionshifting_design}
\title{Datatset of the design for the data attentionshifting_signal}
\format{
A data frame with 120 rows and 10 variables.
}
\usage{
data(attentionshifting_design)
}
\description{
Design of an experiment measuring the EEG brain activity of 15 participants who have been shown images of neutral and angry faces. Those faces were shown at a different visibility 16ms and 166ms and were displayed either to the left or to the right of a screen. The laterality, sex, age, and 2 measures of anxiety for each subjects are also available. The amplitude of the EEG recording are located in the dataset \link{attentionshifting_signal}.

\itemize{
\item id : identifier of the subject.
\item visibility : time of exposure to the image (16ms: subliminal or 166ms:supraliminal).
\item emotion : type of emotion of the image (angry or neutral).
\item direction : position of image one the screen (left or right).
\item laterality_id : measure of laterality of the subject.
\item age : age of the subject.
\item sex : sex of the subject.
\item STAIS_state : measure of the state of anxiety of the subject.
\item STAIS_trait : measure of the personality trait of anxiety of the subject.
}
}
\seealso{
Other dataset: 
\code{\link{attentionshifting_signal}},
\code{\link{emergencycost}},
\code{\link{jpah2016}}
}
\concept{dataset}

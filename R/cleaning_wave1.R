library(tidyverse)
path = "/Users/michaelfive/Library/CloudStorage/GoogleDrive-wuzezhen33@gmail.com/My Drive/WB Armenia Study/Data/wave1"
mplus_path = "/Users/michaelfive/Code/WB_Armenia_FA/Mplus/wave1"

# Student data
dat_stu_b <- haven::read_dta(file.path(path, "pilot-cleaned_nopii.dta"))

dat_stu_b <- dat_stu_b |> 
  select(studentid, age:country,
         dass_Q1:dass_Q21,
         phq_Q1:phq_Q8,
         gad_Q1:gad_Q7,
         ghq_Q1:ghq_Q12,
         erica_Q1:erica_Q17,
         sswq_Q1:sswq_Q16,
         attitudes_Q1:attitudes_Q6
         ) |> 
  janitor::clean_names()

names(dat_stu_b) <- gsub("(\\w+)_q(\\d+)", "\\1\\2_1", names(dat_stu_b))
names(dat_stu_b)[87:92] <- paste0("atti", 1:6, "_1")

# create training and testing sets
set.seed(1234)
dat_stu_b$half <- NA
dat_stu_b$half <- sample(c(rep(0, nrow(dat_stu_b)/2), rep(1, nrow(dat_stu_b)/2)),
                       size = nrow(dat_stu_b),
                       replace = F)

# reverse code items
dat_stu_b <- dat_stu_b |> 
  mutate_at(vars(erica1_1:erica8_1, # emotional control
                 erica9_1, erica12_1, # emotional self-awareness
                 erica17_1 # situational responsiveness
                 ),
            function(x){6 - x})

write_csv(dat_stu_b, file.path(path, "dat_stu_1.csv"))
write.table(dat_stu_b, file.path(mplus_path, "dat_stu_1.txt"), 
            col.names = F, row.names = F)

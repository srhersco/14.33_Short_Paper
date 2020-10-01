import delimited "/Users/srhersco/Downloads/Voting.csv"

gen Dem = real(democrat)

gen TotalVotes = Dem + republican

gen PercentDem = Dem/TotalVotes

gen Reg = real(registered)

gen VoterTurnout = TotalVotes/Reg

reg PercentDem VoterTurnout

gen PrcpVotingDay = real(prcpmm)

gen PrcpAve = real(prcpmm1015)

reg VoterTurnout PrcpVotingDay 

test PrcpVotingDay

reg VoterTurnout PrcpVotingDay PrcpAve

gen Turnout = real(turnout)

*Creating first regression Figure
reg Turnout PrcpVotingDay
test PrcpVotingDay
graph twoway scatter Turnout PrcpVotingDay
graph twoway (lfit Turnout PrcpVotingDay) (scatter Turnout PrcpVotingDay), title("Voter Turnout versus Precipitation on Election Day") ytitle("Voter Turnout") xtitle("Precipitation on Election Day")


*Creating Second Regression Figure
reg PercentDem Turnout

graph twoway (lfit PercentDem Turnout) (scatter PercentDem Turnout), title("Democratic Vote Share Gen. Election versus Voter Turnout") ytitle("Democratic Vote Share Gen. Election") xtitle("Voter Turnout")

*Creating Summary Statistics for Table

summarize PercentDem
summarize Turnout
summarize PrcpVotingDay
summarize PrcpAve
summarize PercentDemSen

*Find 10th and 90th percentiles for rain
centile (PrcpVotingDay), centile (10 90)

ivregress 2sls PercentDem (Turnout = PrcpVotingDay), vce(robust)

ivregress 2sls PercentDem PrcpAve (Turnout = PrcpVotingDay), vce(robust)

*Creating Table
eststo: ivregress 2sls PercentDem (Turnout = PrcpVotingDay), vce(robust)
eststo: ivregress 2sls PercentDem PrcpAve (Turnout = PrcpVotingDay), vce(robust)
esttab using impact_iv_reg.tex, label title("Impacts of Increased Voter Turnout on Percentage of Votes Received by the Democrats in General Election:  IV regression") mtitles("Regrssion 1" "Regrssion 2")  addnote( " ") nodepvars se ar2  replace star(+ 0.10 * 0.05) nonumbers eqlabels("" "First stage")

*Second Table I created in LaTex using the code from the first table above

*Senate Races*



gen DemSen = real(demsenate)

gen TotalVotesSen = real(totalsenate)

gen PercentDemSen = DemSen/TotalVotesSen

reg Turnout PrcpVotingDay

ivregress 2sls PercentDemSen (Turnout = PrcpVotingDay), vce(robust)

ivregress 2sls PercentDemSen PrcpAve (Turnout = PrcpVotingDay), vce(robust)


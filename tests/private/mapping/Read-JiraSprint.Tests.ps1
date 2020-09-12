Describe "Test Sprint Parsing" {
    Context "Sprints that have broken parsing" {
        It "Parses SISTADMU sprint without breaking" {
            $sprintString = "@{id=992; name=Admin Unit Sprint 56,  Sept 5; state=closed; boardId=69; goal=; startDate=2020-08-24T20:46:04.947Z; endDate=2020-09-06T20:46:00.000Z; completeDate=2020-09-08T20:26:31.987Z}"
            
            { Read-JiraSprint $sprintString 1 } | Should -Not -Throw
        }

        It "Parses GSIS sprint without breaking" {
            $sprintString = "@{id=994; name=GSIS Sprint 21; state=active; boardId=187; goal=Complete all the preparation for launching the GradPoint Financial rebranding, begin work on Academic Report Enhancements; startDate=2020-08-31T20:01:36.696Z; endDate=2020-09-12T01:53:00.000Z}"

            { Read-JiraSprint $sprintString 1 } | Should -Not -Throw
        }
    }
}
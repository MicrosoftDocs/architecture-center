Before selecting the "Create pull request" button:  

1. Enter a meaningful title above^, using a prefix if necessary and keywords "New" or "Update" indicating the nature of changes.

2. Describe the summary, scope, and intent of this PR:  
[REPLACE-THIS-TEXT]  

3. Insert links(s) to any related work item(s) or supporting detail:  
[DELETE-OR-REPLACE-THIS-TEXT]   

  






































































  
<details><summary>AFTER YOUR PR HAS BEEN CREATED, expand this section for tips and additional instructions.</summary>    
      

These are common guidelines for contributions across the repos managed by the Cloud Architecture Content Team (CACT). Some repositories may have additional specific requirements that are not listed here.   

## Guidance for all contributors  
  
  | **Topic** | **Guidance** |
  | ----------| ------------ |
  | **Draft PR** | If your PR will be a work-in-progress for more than a day or two, select the **Convert to draft** link in the upper right of the page (under **Reviewers**) to change it to a draft. For future reference, you can also do this using the **Create pull request** button drop-down during PR creation. | 
  | **ms.date metadata** | <ul><li>Don't update an article's "ms.date" metadata property unless you've done a **full freshness review** of the content. A full freshness review includes changes required to correct or improve the **full** technical accuracy of the article.</li><li>Don't update "ms.date" if you're doing targeted changes to improve non-technical aspects of the article, such as editorial quality, art improvements, article template alignment, etc.</li><li>If you've changed any "ms.date" properties for work that wasn't part of full review for freshness, please reset them to their previous value.</li></ul> | 
  | **Placement and linking** | If you're creating a new article or articles, include updates to the related TOC.yml file to propose where the article(s) should be placed. Also consider other places within the document set where it would be beneficial to cross-reference and link to your new article(s). | 
  | **PR build** | After you open your PR, and for each successive commit that you push to your branch, the publishing platform will run validation on the files in your pull request. A summary of the build results for each file will be inserted inline into your pull request, which includes any build suggestions/warnings/errors. PRs cannot be merged until all build errors and most warnings are resolved. |
  | **Publishing** | Following a successful merge, most repos publish to the live site at least once per (business) day, usually around 10am Pacific. |
  | **Additional resources** | <ul><li>[Learn.Microsoft.Com contributor guide](https://review.learn.microsoft.com/help/contribute/?branch=main)</li></ul>
  
## Additional guidance for private repos and internal contributors  

  | **Topic** | **Guidance** | 
  | ----------| ------------ | 
  | **PR size** | If your PR is more than ~5 lines of changes, or you'd like for the changes to go through editorial or larger review, open a contribution request at https://aka.ms/Contribution and include a link to the PR in response #8. Once it's processed, you'll be notified of the next steps.  |
  | **PR title prefix** | Select the **Edit** button to the right of the PR title if you need to revise it. The following prefixes are reserved for specific contribution types:<br/><br/><ul><li>**[Quality Check]** - maintenance work related to content quality (edit passes, art improvements, template alignment)</li><li>**[LinkFix]** - recurring/adhoc PRs to correct link URLs</li><li>**[Pipeline]** - new/updated contributor success pipeline content</li><li>**[WIP]** - a work-in-progress draft requiring several days/weeks</li></ul> |
  | **PR preview** | Following successful build of your PR, publishable files will also include **Preview URL** links to staged previews of your new/updated articles. Be sure to review these for verification of your intended contributions, or to send to other internal contributors for review. |
  | **PR sign-off (public repo)** | If an article you own is updated in a public repo PR, you are responsible for sign-off. You will be automatically notified via email. The PR will not be merged until you've had a chance to review and sign-off. |
  | **PR sign-off (private repo)** | After you've completed your proposed changes, addressed build warnings, and completed all review work, you can begin the sign-off process for review and merge:<br/><br/><ol><li>If your PR is in draft mode, remove "[WIP]" from the title and select **Ready for review** button at the bottom of the PR.</li><li>Enter "#sign-off" in a new comment. This comment indicates that **you're confident the work meets or exceeds Microsoft's standards for publication**, and will trigger the review process.</li><li>Your PR may be selected for initial review by the CACT. Following CACT review, you may receive questions or requests for additional changes. You should have initial feedback from CACT review within a few business days. If you have an urgent request or need to contact the team, please mention `@MicrosoftDocs/cloud-architecture-content-team-pr-reviewers` in your PR and someone will get back to you. After CACT review is complete, a `CACT #sign-off` will be added.</li><li>Final review/merge is done by the PR review team. The PR team may also respond with feedback, categorized as "Blocking" (requires action from you), or "Non-blocking" (to be addressed in a future PR).</li></ol> |
  | **Additional resources** | <ul><li>[Learn.Microsoft.Com internal contributor guide](https://review.learn.microsoft.com/help/contribute/?branch=main)</li><li>Authoring templates: [architecture-center-pr](https://review.learn.microsoft.com/help/contribute/architecture-center/templates/sample-solution-templates?branch=main), [well-architected-pr](https://review.learn.microsoft.com/help/contribute/global-waf-template?branch=main)</li><li>To contact the CACT use [e-mail](mailto:cact-pr-reviewers@microsoft.com?subject=Help%20with%20pull%20request), or @mention our GitHub team in your PR comments using: `@MicrosoftDocs/cloud-architecture-content-team-pr-reviewers`</li></ul>
</details>
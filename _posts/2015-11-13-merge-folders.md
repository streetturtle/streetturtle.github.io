---
layout: post
title: "Merge folders in Alfresco"
date: 2015-11-13 19:21:06
comments: true
tags: 
  - alfresco
description: Recently I needed to merge two folders in Alfresco, I didn't find any relevant method so I come up with following utility method to merge folders.
comments: true
---

## Problem description

Alfresco provides very good and rich Java API to maintain NodeRefs, there are `nodeService` and `fileFolderService` with many convenient methods, but applicable to the problem below I couldn't find relevant one.

Let's pretend that we have a folder with a typo in the name (*HR office*). When it was discovered instead of renaming it user just created another folder with a proper name (*HR office*). So it would be something like this:

{% highlight bash %}
Recruitment
├── HR office
│   └── CV
│       ├── CV_Leonardo.pdf
│       └── CV_Donatello.pdf
└── HR ofice
    └── CV
        ├── CV_Michelangelo.pdf
        └── CV_Raphael.pdf
{% endhighlight bash %}

So now we want to merge these two folders - merge *HR ofice* into *HR office*.

## Solution

First thing which comes up is to use some of the services, but since inner folder structure are the same (*CV* folder exists in both of them),

 - `fileFolderService#move(moveFrom)` will throw `FileExistsException`
 - `nodeService#moveNode` will throw `DuplicateChildNodeNameException`
 
The proper way to merge them is to recursively check if child nodes of target folder has nodes with the same name as child nodes of source folder. If not then just move child node from source to target, otherwise do the same check with child nodes. Here is the method:


{% highlight java %}
public void mergeFolders(NodeRef source, NodeRef target)
  {
    List<ChildAssociationRef> children = nodeService.getChildAssocs(source);
    logger.info("Merging folders "
                + fileFolderService.getFileInfo(source).getName() + " ("+ source.getId() +") to "
                + fileFolderService.getFileInfo(target).getName() + " ("+ target.getId() +"), "
                + "children to move " + children.size());

    for (ChildAssociationRef childAssoc : children)
    {
      NodeRef childNodeRef = childAssoc.getChildRef();
      try
      {
        logger.info("Moving " + fileFolderService.getFileInfo(childNodeRef).getName() + " ("+ childNodeRef.getId() + ")"
                   + " from " + fileFolderService.getFileInfo(source).getName() + " ("+ source.getId() + ")"
                   + " to " + fileFolderService.getFileInfo(target).getName() + " ("+ target.getId() + ")");

        if (nodeService.getChildrenByName(target, ContentModel.ASSOC_CONTAINS,
          Arrays.asList(fileFolderService.getFileInfo(childNodeRef).getName())).size() == 0)
        {
          fileFolderService.moveFrom(childNodeRef, source, target, null);
        }
        else
        {
          NodeRef childWithSameName = nodeService.getChildByName(target, ContentModel.ASSOC_CONTAINS,
            fileFolderService.getFileInfo(childNodeRef).getName());
          mergeFolders(childNodeRef, childWithSameName);
        }
      }
      catch (FileNotFoundException | FileExistsException e)
      {
        e.printStackTrace();
      }
    }
  }
{% endhighlight java %}

If you want to use it please be very careful - source and target folders should be identical (name, aspects, type, inner folder structure) like in the example above. Otherwise you can lose some important information about the source folder. I guess this is why Alfresco doesn't have such method. Also note that source folder is not deleted, it has to be deleted explicitly. 

After running this method for folders from the example above the structure will be following:

{% highlight bash %}
Recruitment
└── HR office
    └── CV
        ├── CV_Leonardo.pdf
        ├── CV_Donatello.pdf
        ├── CV_Michelangelo.pdf
        └── CV_Raphael.pdf
{% endhighlight bash %}


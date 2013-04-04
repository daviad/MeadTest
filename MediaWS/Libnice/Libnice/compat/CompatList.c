/*
 *  CompatList.c
 *  libnice-darwin
 *
 *  Created by Vadim Tsyganok on 8/19/10.
 *  Copyright 2010 tsyganok.com. All rights reserved.
 *
 */

#include "CompatList.h"
#include <stdlib.h>

CompatList* compat_list_prepend(CompatList* list, void* data)
{
	CompatList* new_head = malloc(sizeof(CompatList));
	new_head->data = data;
	new_head->next = list;
	if (list)
		list->prev = new_head;
	return new_head;
}

CompatList* compat_list_append(CompatList* list, void* data)
{
	CompatList* last = compat_list_last(list);
	CompatList* new_tail = malloc(sizeof(CompatList));
	
	new_tail->data = data;
	new_tail->prev = last;
	new_tail->next = NULL;
	if (last)
	{
		last->next = new_tail;
		return list;
	}
	return new_tail;
}
CompatList* compat_list_remove(CompatList *list, const void* data)
{
	for (CompatList* el = list;el;el = el->next)
	{
		if (el->data != data) continue;
		CompatList* prev = el->prev;
		CompatList* next = el->next;
		if (next)
			next->prev = prev;
		if (prev)
			prev->next = next;
		free(el);
		// if we removed first element, return next
		if (el == list) return next;
		return list;
	}
	return list;
}

CompatList* compat_list_last(CompatList *list)
{
	if (!list)return NULL;
	while (list->next) list = (CompatList*)list->next;
	return list;
}

CompatList* compat_list_concat (CompatList* list, CompatList* other)
{
	CompatList* tail = compat_list_last(list);
	tail->next = other;
	other->prev = tail;
	return list;
}

void compat_list_foreach(CompatList *list, CompatFunc func, void* user_data)
{
	for (CompatList* el = list; el; el = el->next)
		func(el->data, user_data);
}

void compat_list_free(CompatList *list)
{
	if(!list) return;
	
	CompatList *tmp;
	tmp = list;
	
	while(list = list->next) {
		
		//if(tmp->data) free(tmp->data);
		free(tmp);
		
		tmp = list;
	}
	
	//if(tmp->data) free(tmp->data);
	free(tmp);
}


int compat_list_length(CompatList *list)
{
	if(!list) return 0;
	
	int cnt = 1;
	
	while(list = list->next) cnt++;
	
	return cnt;
}

CompatList* compat_list_first(CompatList *list)
{
	if (!list)return NULL;
	while (list->prev) list = (CompatList*)list->prev;
	return list;
}

CompatList *compat_list_delete_link(CompatList *list, CompatList *link)
{
	if(!list) return NULL;
	if(!link) return list;
	
	for (CompatList* el = list;el;el = el->next)
	{
		if (el != link) continue;
		CompatList* prev = el->prev;
		CompatList* next = el->next;
		if (next)
			next->prev = prev;
		if (prev)
			prev->next = next;
		free(el);
		// if we removed first element, return next
		if (el == list) return next;
		return list;
	}
	return list;
}


//singly-linked lists

void compat_slist_free(CompatSList *list)
{
	if(!list) return;
	
	CompatSList *tmp;
	tmp = list;
	
	while(list = list->next) {
		
		compat_slist_free1(tmp);
		
		tmp = list;
	}
	
	//if(tmp->data) free(tmp->data);
	free(tmp);
}

CompatSList *compat_slist_append(CompatSList *list, void *data)
{
	
	CompatSList *new_list;
	CompatSList *last;
	
	new_list = malloc(sizeof(CompatSList));
	new_list->data = data;
	new_list->next = NULL;
	
	if (list)
    {
		last = compat_slist_last (list);
		last->next = new_list;
		
		return list;
    }
	else
		return new_list;
	
}

CompatSList *compat_slist_last(CompatSList *list)
{
	if(!list) return NULL;
	
	while (list->next)
		list = list->next;
    
	return list;
}
void compat_slist_foreach(CompatSList *list, CompatFunc func, void* user_data)
{
	for (CompatSList* el = list; el; el = el->next)
		func(el->data, user_data);

}

int compat_slist_length(CompatSList *list)
{
	if(!list) return 0;
	int cnt = 1;
	while(list = list->next) cnt++;
	return cnt;
}

CompatSList *compat_slist_next(CompatSList *l)
{
	if(!l) return NULL;
	return l->next;
}

CompatSList *compat_slist_nth(CompatSList *list, int n)
{
	if(!list || n < 0) return NULL;
	
	while (n-- > 0 && list) list = list->next;
	
	return list;
}

void compat_slist_free1(CompatSList *l)
{
	if(!l) return;
	//if(l->data) free(l->data);
	free(l);
}

CompatSList *compat_slist_remove(CompatSList *list, void *data)
{
	if(!list) return NULL;
	
	CompatSList *prev, *head;
	
	head = list;
	
	for(prev = NULL; list != NULL; list = list->next) {
		
		if(list->data == data) { //this is our guy
			if(prev != NULL) {
				//not null => this isn't the first element, just remove it and return the original head
				prev->next = list->next;
				compat_slist_free1(list);
				return head; //and return the original list head
			} else {
				
				//removing the very first element, going to have a new head
				head = list->next;
				compat_slist_free1(list);
				return head;
			}
		}
		
		prev = list;
	}
	
	return head; //nothing happened, returning the original
	
}

// We assume that slist is already sorted by given func.
CompatSList* compat_slist_insert_sorted(CompatSList* list, void* data, CompatCompareFunc f)
{
	CompatSList* newEl = malloc(sizeof(CompatSList));
	newEl->data = data;

	if (!list)
	{
		// First element (and only one)
		newEl->next = NULL;
		return newEl;
	}
	CompatSList* prev = NULL;
	CompatSList* el;
	for (el = list; el; el=el->next)
	{
		if (f(data, el->data) > 0) 
		{
			// data became greater than current element. insert newEl before current
			if (prev)
			{
				// We are in the middle
				prev->next = newEl;
				newEl->next = el;
				return list;
			}
			else
			{
				// We don't have any previous. Beginning of the list
				newEl->next = el;
				return newEl;
			}
		}
		prev = el;		
	}
	// Insert at the end.
	el->next = newEl;
	return list;
}
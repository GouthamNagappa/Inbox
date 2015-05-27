package com.adaptavant.gmail;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.jdo.PersistenceManager;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GmailController {

	static PersistenceManager pm;
	private int tempVariable=0;
	
	
	@RequestMapping(value = "/")
	public ModelAndView goToIndex(){
		if (tempVariable < 1) {
			tempVariable++;

				Inbox inbox = new Inbox();
				inbox.getName();
				inbox.setListOfTabs();
				pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
				try {
					pm.makePersistent(inbox);
				} catch (Exception e) {
					System.out.println(e);
				} finally {
					pm.close();
				}
		}
		ModelAndView model = new ModelAndView("redirect:/0");
		return model;
	}
	
	@RequestMapping(value = "/{tabIndex}")
	public ModelAndView getIndex(@PathVariable int tabIndex){
		
		ModelAndView model;
		
		try{
		pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
		Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
		
			if (inbox.getListOfTabs().size() != 0) {
				// Listing Tabs on left_panel
				List<Tab> tabList = inbox.getListOfTabs();
				String tabListObject = "[ ";
				for (int i = 0; i < tabList.size(); i++) {
					tabListObject += "{ tabName:\""
							+ tabList.get(i).getTabName()
							+ "\", tabDescription:\""
							+ tabList.get(i).getTabDescription()
							+ "\", tabNumberOfMail:\""
							+ tabList.get(i).getNumberOfMails() + "\"},";
				}
				tabListObject = tabListObject.substring(0,
						tabListObject.length() - 1)
						+ "]";
				
				// List Mails on Right_panel
				if (tabIndex == 0) {
					tabIndex += 1;
				}
				
				List<Mail> mailList = tabList.get(tabIndex - 1).getMailList();
				DateFormat dateFormat = new SimpleDateFormat("dd/MM/YYYY - hh:mm a");
				
				String tabName = "\"Create Tab\"";
				if(tabList.get(tabIndex-1)!=null)
					tabName ="\""+ tabList.get(tabIndex-1).getTabName()+"\"";
				
				String tabMailObject = "[ ";
				for (int i = 0; i < mailList.size(); i++) {
					tabMailObject += "{tabIndex:\"" + tabIndex
							+ "\",belongsToTab:\""
							+ mailList.get(i).getBelongsToTab()
							+ "\", mailFromName:\""
							+ mailList.get(i).getMailFromName()
							+ "\", mailToName:\""
							+ mailList.get(i).getMailToName()
							+ "\",mailSubject:\""
							+ mailList.get(i).getMailSubject()
							+ "\", mailBody:\"" + mailList.get(i).getMailBody()
							+ "\", starFlag:\"" + mailList.get(i).getStarFlag()
							+ "\",readStatusFlag:\""
							+ mailList.get(i).getReadStatusFlag()
							+ "\", mailTime:\""
							+ dateFormat.format(mailList.get(i).getMailTime())
							+ "\"},";
				}
				tabMailObject = tabMailObject.substring(0,tabMailObject.length() - 1)+ "]";

				// sending model
				model = new ModelAndView("index.jsp");
				model.addObject("tabListObject", tabListObject);
				model.addObject("tabName",tabName);
				model.addObject("tabMailObject", tabMailObject);
				return model;
			}else{
			model = new ModelAndView("index.jsp");
			model.addObject("errorMessage","Error");
			return model;
		}
		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("index.jsp");
			model.addObject("errorMessage","Error");
			return model;
		}
		finally{
			pm.close();
		}
		
	}
	
	@RequestMapping(value = "/compose")
	public ModelAndView composeMail(){
		ModelAndView model = new ModelAndView("Compose.jsp");
		return model;
	}
	
	@RequestMapping(value = "/createtab")
	public ModelAndView createTab(){
		ModelAndView model = new ModelAndView("CreateTab.jsp");
		return model;
	}
	
	
	@RequestMapping(value="/mailsent")
	public ModelAndView mailSent(@ModelAttribute Mail mail){
		ModelAndView model;
		if("".equals(mail.getBelongsToTab())){
			model = new ModelAndView("Compose.jsp");
			model.addObject("errorMessage","Error: Tab Field Cannot be Empty");
			return model;
		}
		
		if("".equals(mail.getMailToName())){
			model = new ModelAndView("Compose.jsp");
			model.addObject("errorMessage","Error: From Field Cannot be Empty");
			return model;
		}
		boolean checker = false;
		pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
		try{
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			List<Tab> tempList = inbox.getListOfTabs();
			for(int i=0;i<tempList.size();i++){
				Tab tempTab = tempList.get(i);
				if(tempTab.getTabName().equals(mail.getBelongsToTab())){
					tempTab.addMailList(mail);
					tempTab.setNumberOfMails();
					checker = true;
				}
			}
			
			if(!checker){
				model = new ModelAndView("Compose.jsp");
				model.addObject("errorMessage","Error: "+mail.getBelongsToTab()+" does not exists.");
				return model;
			}
			
		}catch(Exception e){
			model = new ModelAndView("Compose.jsp");
			model.addObject("errorMessage","Error: "+mail.getBelongsToTab()+" does not exists.");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("redirect:/");
		return model;
	}
	
	@RequestMapping(value="/tabcreated")
	public ModelAndView tabCreated(@ModelAttribute Tab tab){
		ModelAndView model;
		if("".equals(tab.getTabName())){
			model = new ModelAndView("CreateTab.jsp");
			model.addObject("errorMessage","Error: Tab Field Cannot Be Empty");
			return model;
		}

		pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
		
		try {
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			List<Tab> tempList = inbox.getListOfTabs();
			List<String> tabNameList = new ArrayList<String>();
			if (tempList.size() != 0) {
				for (int i = 0; i < tempList.size(); i++) {
					tabNameList.add(tempList.get(i).getTabName());
				}
				if (tabNameList.contains(tab.getTabName())) {
					model = new ModelAndView("CreateTab.jsp");
					model.addObject("errorMessage","Error: Tab " + tab.getTabName() + " Exists");
					return model;
				}else{
					inbox.addListOfTabs(tab);
				}
			}else{
				inbox.addListOfTabs(tab);
			}
		}catch(Exception e){
			model = new ModelAndView("CreateTab.jsp");
			model.addObject("errorMessage","Error: Tab Creation Failed");
			return model;
		} finally {
			pm.close();
		}
		model = new ModelAndView("redirect:/");
		return model;
	}
	
	@RequestMapping(value="/openmail", method= RequestMethod.GET)
	public ModelAndView openMail(@RequestParam int tabIndex,@RequestParam int mailIndex){
		ModelAndView model;
		try{
			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			
			if(tabIndex==0){
				tabIndex+=1;
			}
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			List<Tab> tabList = inbox.getListOfTabs();
			String tabNamesList="[";
			for(int i=0;i<tabList.size();i++){
				tabNamesList+= "\""+tabList.get(i).getTabName() +"\",";
			}
			tabNamesList = tabNamesList.substring(0,tabNamesList.length() - 1)+ "]";
			
			List<Mail> mailList = tabList.get(tabIndex-1).getMailList();
			mailList.get(mailIndex).setReadStatusFlag(true);
			DateFormat dateFormat = new SimpleDateFormat("dd/MM/YYYY hh:mm a");
			model = new ModelAndView("OpenMail.jsp");
			model.addObject("tabNamesList",tabNamesList);
			model.addObject("mailFromName", mailList.get(mailIndex).getMailFromName());
			model.addObject("mailToName", mailList.get(mailIndex).getMailToName());
			model.addObject("mailSubject", mailList.get(mailIndex).getMailSubject());
			model.addObject("mailBody", mailList.get(mailIndex).getMailBody());
			model.addObject("starFlag", mailList.get(mailIndex).getStarFlag());
			model.addObject("readStatusFlag", mailList.get(mailIndex).getReadStatusFlag());
			model.addObject("mailTime", dateFormat.format(mailList.get(mailIndex).getMailTime()));
			model.addObject("tabIndex",tabIndex );
			model.addObject("mailIndex",mailIndex);
			model.addObject("maxNumberOfMails",mailList.size());
			return model;
		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("redirect:/");
			return model;
		}finally{
			pm.close();
		}
	}
	
	@RequestMapping(value="/startoggle", method= RequestMethod.GET)
	public ModelAndView starToggle(@RequestParam int tabIndex,@RequestParam int mailIndex,@RequestParam boolean starFlag){
		ModelAndView model;
		try{
			
			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			
			if(tabIndex==0){
				tabIndex+=1;
			}
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			List<Tab> tabList = inbox.getListOfTabs();
			List<Mail> mailList = tabList.get(tabIndex-1).getMailList();
			if(starFlag==false)
				mailList.get(mailIndex).setStarFlag(true);
			else
				mailList.get(mailIndex).setStarFlag(false);

		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("/");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("redirect:/openmail?tabIndex="+tabIndex+"&mailIndex="+mailIndex);
		return model;
	}
	
	@RequestMapping(value="/markunread", method= RequestMethod.GET)
	public ModelAndView markUnread(@RequestParam int tabIndex,@RequestParam int mailIndex){
		ModelAndView model;
		try{
			
			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			
			if(tabIndex==0){
				tabIndex+=1;
			}
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			List<Tab> tabList = inbox.getListOfTabs();
			List<Mail> mailList = tabList.get(tabIndex-1).getMailList();
			mailList.get(mailIndex).setReadStatusFlag(false);

		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("/");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("redirect:/"+tabIndex);
		return model;
	}
	
	
	@RequestMapping(value="/deletemail", method= RequestMethod.GET)
	public ModelAndView deleteMail(@RequestParam int tabIndex,@RequestParam int mailIndex){
		ModelAndView model;
		try{
			
			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			
			if(tabIndex==0){
				tabIndex+=1;
			}
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			Tab tab = inbox.getListOfTabs().get(tabIndex-1);
			Mail mail = inbox.getListOfTabs().get(tabIndex-1).getMailList().get(mailIndex);
			tab.removeMailList(mailIndex);
			tab.setNumberOfMails();
			pm.deletePersistent(mail);

		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("/");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("redirect:/");
		return model;
	}
	
	@RequestMapping(value="/deletetab", method=RequestMethod.GET)
	public ModelAndView deleteTab(@RequestParam int tabIndex){
		ModelAndView model;
		try{

			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			
			Tab tab = inbox.getListOfTabs().get(tabIndex);
			List<Mail> mailList = tab.getMailList();
			
			List<Mail> tempMailList = (List<Mail>) pm.detachCopyAll(mailList);
			
			int tempIndex;
			if(tabIndex!=0)
				tempIndex=0;
			else
				tempIndex=1;
			
			inbox.getListOfTabs().get(tempIndex).addGroupMailList(tempMailList);
			inbox.getListOfTabs().get(tempIndex).setNumberOfMails();
			
			inbox.removeListOfTabs(tabIndex);
			
			pm.deletePersistentAll(mailList);
			pm.deletePersistent(tab);
			

		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("redirect:/");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("redirect:/");
		return model;
	}
	
	@RequestMapping(value="/movemail", method=RequestMethod.GET)
	public ModelAndView moveMail(@RequestParam int tabIndex,@RequestParam int mailIndex ,@RequestParam int moveToTabIndex){
		ModelAndView model;
		try{
			
			//Removing from old tab
			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			Inbox inbox = pm.getObjectById(Inbox.class,"MailBox");
			Mail mail = inbox.getListOfTabs().get(tabIndex-1).getMailList().get(mailIndex);
			
			Mail copyMail = (Mail) pm.detachCopy(mail);
			
			inbox.getListOfTabs().get(tabIndex-1).removeMailList(mailIndex);
			inbox.getListOfTabs().get(tabIndex-1).setNumberOfMails();
			pm.deletePersistent(mail);
			
			//adding to new tab
			inbox.getListOfTabs().get(moveToTabIndex).addMailList(copyMail);
			inbox.getListOfTabs().get(moveToTabIndex).setNumberOfMails();
		}catch(Exception e){
			System.out.println(e);
			model = new ModelAndView("redirect:/");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("redirect:/");
		return model;
	}
	
	@RequestMapping(value="/search", method=RequestMethod.GET)
	public ModelAndView moveMail(@RequestParam String searchText){
		ModelAndView model;
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/YYYY - hh:mm a");
		if(searchText==""){
			model = new ModelAndView("redirect:/");
			return model;
		}
		
		
		String tabMailObject="[ ";
		String tabListObject = "[ ";
		try{
			pm = PersitenceManagerFactoryClass.get().getPersistenceManager();
			Inbox inbox = pm.getObjectById(Inbox.class, "MailBox");
			List<Tab> listOfTabs = inbox.getListOfTabs();
			
			if (listOfTabs.size() != 0) {
				// Listing Tabs on left_panel
				List<Tab> tabList = inbox.getListOfTabs();
				for (int i = 0; i < tabList.size(); i++) {
					tabListObject += "{ tabName:\""
							+ tabList.get(i).getTabName()
							+ "\", tabDescription:\""
							+ tabList.get(i).getTabDescription()
							+ "\", tabNumberOfMail:\""
							+ tabList.get(i).getNumberOfMails() + "\"},";
				}
				tabListObject = tabListObject.substring(0,
						tabListObject.length() - 1)
						+ "]";
			}
				// List Mails on Right_panel
			
			for (int tabIndex = 0; tabIndex < listOfTabs.size(); tabIndex++) {
				Tab tab = listOfTabs.get(tabIndex);
				List<Mail> listOfMails = tab.getMailList();
				for (int mailIndex = 0; mailIndex < listOfMails.size(); mailIndex++) {
					Mail mail = listOfMails.get(mailIndex);
					if (mail.getMailFromName().toLowerCase().contains(searchText.toLowerCase()) || mail.getMailSubject().toLowerCase().contains(searchText.toLowerCase()) || mail.getMailBody().toLowerCase().contains(searchText.toLowerCase())) {
						tabMailObject+="{tabIndex:\"" + tabIndex
								+ "\",belongsToTab:\""
								+ mail.getBelongsToTab()
								+ "\", mailFromName:\""
								+ mail.getMailFromName()
								+ "\", mailToName:\""
								+ mail.getMailToName()
								+ "\",mailSubject:\""
								+ mail.getMailSubject()
								+ "\", mailBody:\"" + mail.getMailBody()
								+ "\", starFlag:\"" + mail.getStarFlag()
								+ "\",readStatusFlag:\""
								+ mail.getReadStatusFlag()
								+ "\", mailTime:\""
								+ dateFormat.format(mail.getMailTime())
								+ "\"},";
					}
				}
			}

			tabMailObject = tabMailObject.substring(0,tabMailObject.length() - 1)+ "]";
		}catch(Exception e){
			model = new ModelAndView("redirect:/");
			return model;
		}finally{
			pm.close();
		}
		model = new ModelAndView("index.jsp");
		model.addObject("tabMailObject", tabMailObject);
		model.addObject("tabListObject",tabListObject);
		return model;
	}
	
}

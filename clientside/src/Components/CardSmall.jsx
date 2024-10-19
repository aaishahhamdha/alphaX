import * as React from 'react';
import List from '@mui/joy/List';
import ListDivider from '@mui/joy/ListDivider';
import ListItem from '@mui/joy/ListItem';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import '../index.css'
import FormFood from './FormFood';

export default function CardSmall() {
    const [open, setOpen] = React.useState(false);

    const handleClickOpen = () => {
      setOpen(true);
    };
  
    const handleClose = () => {
      setOpen(false);
    };

  return (
    <div>
    <List
      orientation="horizontal"
      variant="outlined"
      sx={{
        flexGrow: 0,
        mx: 'auto',
        '--ListItem-paddingY': '1rem',
        borderRadius: 'sm',
        backgroundColor: 'var(--background-color)'
      }}
    >
      <ListItem sx={{
        fontSize: 'var(--font-size-normal)',
        color: 'var(--text-primary)'
      }}>
        Mabel Boylehfsfhlueoifuj
      </ListItem>
      <ListDivider inset="gutter" />
      <ListItem sx={{
        fontSize: 'var(--font-size-normal)',
        fontWeight: 'bold',
        color: 'black'
      }}>
        Boyd Burt
      </ListItem>
    </List>

    <Button variant="outlined" onClick={handleClickOpen} sx={{marginTop: '2%', color: 'var(--background-color)', backgroundColor: 'var(--orange)'}}>
        Add Food
    </Button>
    <Dialog
        open={open}
        onClose={handleClose}
        sx={{
            width: '100%'
        }}
        PaperProps={{
        component: 'form',
        onSubmit: (event) => {
            event.preventDefault();
            const formData = new FormData(event.currentTarget);
            const formJson = Object.fromEntries(formData.entries());
            const email = formJson.email;
            console.log(email);
            handleClose();
        },
        
        }}
    >
        <DialogTitle>Add Food</DialogTitle>
        <DialogContent>
        <DialogContentText>
            <FormFood></FormFood>
        </DialogContentText>
        </DialogContent>
        <DialogActions>
        <Button onClick={handleClose}>Cancel</Button>
        </DialogActions>
    </Dialog>
  </div>
  );
}